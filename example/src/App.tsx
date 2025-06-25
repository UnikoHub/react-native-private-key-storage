import { useState } from 'react';
import { Text, View, StyleSheet, TouchableOpacity } from 'react-native';
import {
  savePrivateKey,
  getPrivateKey,
  getPrivateKeys,
  savePrivateKeys,
  deletePrivateKey,
  deletePrivateKeys,
} from 'react-native-private-key-storage';

export default function App() {
  const [result, setResult] = useState<string>('No result yet');

  const runAsync = async () => {
    try {
      console.log('Starting private key storage example...');

      // Save a private key
      await savePrivateKey('testAccount', 'dGVzdA==');
      setResult('Private key saved successfully');
      console.log('Private key saved successfully');

      // Retrieve the private key
      const privateKey = await getPrivateKey('testAccount');
      console.log(await getPrivateKeys());

      if (privateKey) {
        console.log('Retrieved private key:', privateKey);

        setResult(`Retrieved private key: ${privateKey}`);
      } else {
        setResult('No private key found for testAccount');
        console.log('No private key found for testAccount');
      }
    } catch (error) {
      setResult(`Error: ${(error as Error)?.message}`);
      console.log('Error:', error);
    }
  };

  const runMultipleAsync = async () => {
    try {
      console.log('Starting multiple private key storage example...');
      // Save multiple private keys
      const values: Record<string, string> = {};
      for (let i = 1; i <= 50; i++) {
        values[`account${i}`] = `dGVzdDI=`;
      }
      await savePrivateKeys(values);
      setResult('Multiple private keys saved successfully');
      console.log('Multiple private keys saved successfully');
      // Retrieve all private keys
      const privateKeys = await getPrivateKeys();
      console.log('Retrieved private keys:', privateKeys);
      setResult(`Retrieved private keys: ${JSON.stringify(privateKeys)}`);
    } catch (error) {
      setResult(`Error: ${(error as Error)?.message}`);
      console.log('Error:', error);
    }
  };

  const deleteAsync = async () => {
    try {
      console.log('Flushing private key storage...');
      setResult('Storage flushed successfully');
      await deletePrivateKey('testAccount');
      console.log('Storage flushed successfully');
      const privateKey = await getPrivateKey('testAccount');
      if (privateKey) {
        setResult(`Private key still exists: ${privateKey}`);
        console.log('Private key still exists:', privateKey);
      } else {
        setResult('Private key deleted successfully');
        console.log('Private key deleted successfully');
      }
    } catch (error) {
      setResult(`Error: ${(error as Error)?.message}`);
      console.log('Error:', error);
    }
  };

  const deleteMultipleAsync = async () => {
    try {
      console.log('Deleting multiple private keys...');
      await deletePrivateKeys();
      setResult('Multiple private keys deleted successfully');
      console.log('Multiple private keys deleted successfully');
      const privateKeys = await getPrivateKeys();
      if (privateKeys.length > 0) {
        setResult(`Private keys still exist: ${JSON.stringify(privateKeys)}`);
        console.log('Private keys still exist:', privateKeys);
      } else {
        setResult('All private keys deleted successfully');
        console.log('All private keys deleted successfully');
      }
    } catch (error) {
      setResult(`Error: ${(error as Error)?.message}`);
      console.log('Error:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <TouchableOpacity onPress={runAsync}>
        <Text style={styles.button}>Save & Get Result</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={deleteAsync}>
        <Text style={styles.button}>Delete Result</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={runMultipleAsync}>
        <Text style={styles.button}>Save & Get Multiple Result</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={deleteMultipleAsync}>
        <Text style={styles.button}>Delete Multiple Result</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#fff',
  },
  button: {
    color: 'blue',
    marginTop: 20,
  },
});
