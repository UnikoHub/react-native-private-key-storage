import Foundation
import Security
import LocalAuthentication
import React

public extension PrivateKeyStorageImpl {
  private func deleteData(accountId: String, context: LAContext, reject: RCTPromiseRejectBlock?) -> OSStatus? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accountId,
      kSecUseAuthenticationContext: context
    ]

    let status = SecItemDelete(query as CFDictionary)
    if status == errSecSuccess || status == errSecItemNotFound {
      return status
    }

    reject?(PrivateKeyStorageErrors.delete(status.description).localizedDescription,
            PrivateKeyStorageErrors.delete(status.description).failureReason, nil)
    return nil
  }

  @objc func deletePrivateKey(_ accountId: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    authenticate(reason: localized(key: "AUTH_DELETE_PRIVATE_KEY", value: "Authenticate to delete your private key"), onSuccess: { context in
      guard self.deleteData(accountId: accountId, context: context, reject: reject) != nil else {
        return
      }

      resolve(nil)
    }, onFailure: reject)
  }

  @objc func deletePrivateKeys(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    authenticate(reason: localized(key: "AUTH_DELETE_PRIVATE_KEYS", value: "Authenticate to delete all private keys"), onSuccess: { context in
      let accountIds = self.readAccountIds()
      for accountId in accountIds {
        guard self.deleteData(accountId: accountId, context: context, reject: nil) != nil else {
          continue
        }
      }
      self.saveAccountIds([])
      resolve(nil)
    }, onFailure: reject)
  }
}
