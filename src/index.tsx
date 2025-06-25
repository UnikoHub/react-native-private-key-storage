import PrivateKeyStorage from './NativePrivateKeyStorage';

export function savePrivateKey(
  accountId: string,
  base64Key: string
): Promise<void> {
  return PrivateKeyStorage.savePrivateKey(accountId, base64Key);
}

export function savePrivateKeys(
  privateKeys: Record<string, string>
): Promise<void> {
  return PrivateKeyStorage.savePrivateKeys(privateKeys);
}

export function getPrivateKey(accountId: string): Promise<string | null> {
  return PrivateKeyStorage.getPrivateKey(accountId);
}

export function getPrivateKeys(): Promise<string[]> {
  return PrivateKeyStorage.getPrivateKeys();
}

export function deletePrivateKey(accountId: string): Promise<void> {
  return PrivateKeyStorage.deletePrivateKey(accountId);
}

export function deletePrivateKeys(): Promise<void> {
  return PrivateKeyStorage.deletePrivateKeys();
}
