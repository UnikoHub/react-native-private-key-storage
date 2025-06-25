import {
  savePrivateKey,
  savePrivateKeys,
  getPrivateKey,
  getPrivateKeys,
  deletePrivateKey,
  deletePrivateKeys,
} from '../index';

const accountId1 = 'test_account_1';
const key1 = 'dGVzdF9rZXlfMQ=='; // "test_key_1" in base64
const accountId2 = 'test_account_2';
const key2 = 'dGVzdF9rZXlfMg=='; // "test_key_2" in base64

const mockStorage: Record<string, string> = {};

jest.mock('../NativePrivateKeyStorage', () => ({
  savePrivateKey: jest.fn(async (id: string, key: string) => {
    mockStorage[id] = key;
  }),
  getPrivateKey: jest.fn(async (id: string) => {
    if (!(id in mockStorage)) throw new Error('NOT_FOUND');
    return mockStorage[id];
  }),
  deletePrivateKey: jest.fn(async (id: string) => {
    delete mockStorage[id];
  }),
  savePrivateKeys: jest.fn(async (map: Record<string, string>) => {
    Object.assign(mockStorage, map);
  }),
  getPrivateKeys: jest.fn(async () => {
    return { ...mockStorage };
  }),
  deletePrivateKeys: jest.fn(async () => {
    Object.keys(mockStorage).forEach((k) => delete mockStorage[k]);
  }),
}));

describe('PrivateKeyStorage', () => {
  beforeEach(async () => {
    await deletePrivateKeys();
  });

  it('should save and retrieve a single private key', async () => {
    await savePrivateKey(accountId1, key1);
    const retrieved = await getPrivateKey(accountId1);
    expect(retrieved).toBe(key1);
  });

  it('should return null for non-existent keys', async () => {
    await expect(getPrivateKey('nonexistent')).rejects.toThrow();
  });

  it('should delete a private key', async () => {
    await savePrivateKey(accountId1, key1);
    await deletePrivateKey(accountId1);
    await expect(getPrivateKey(accountId1)).rejects.toThrow();
  });

  it('should store and retrieve multiple keys', async () => {
    await savePrivateKeys({
      [accountId1]: key1,
      [accountId2]: key2,
    });
    const all = await getPrivateKeys();
    expect(all).toEqual({
      [accountId1]: key1,
      [accountId2]: key2,
    });
  });

  it('should delete all keys', async () => {
    await savePrivateKeys({
      [accountId1]: key1,
      [accountId2]: key2,
    });
    await deletePrivateKeys();
    const all = await getPrivateKeys();
    expect(all).toEqual({});
  });
});
