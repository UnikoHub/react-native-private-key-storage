import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  savePrivateKey(accountId: string, base64Key: string): Promise<void>;
  savePrivateKeys(privateKeys: { [key: string]: string }): Promise<void>;
  getPrivateKey(accountId: string): Promise<string | null>;
  getPrivateKeys(): Promise<string[]>;
  deletePrivateKey(accountId: string): Promise<void>;
  deletePrivateKeys(): Promise<void>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('PrivateKeyStorage');
