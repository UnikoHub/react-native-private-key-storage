import Foundation
import Security
import LocalAuthentication
import React

public extension PrivateKeyStorageImpl {
  private func saveData(accountId: String, data: Data, context: LAContext, reject: RCTPromiseRejectBlock) {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accountId
    ]
    SecItemDelete(query as CFDictionary)

    var error: Unmanaged<CFError>?
    guard let access = SecAccessControlCreateWithFlags(
      nil,
      kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
      .userPresence,
      &error
    ) else {
      let rejectError = error?.takeRetainedValue()
      reject(PrivateKeyStorageErrors.accessControl(rejectError?.localizedDescription).localizedDescription, PrivateKeyStorageErrors.accessControl(rejectError?.localizedDescription).failureReason, rejectError)
      return
    }

    var insertQuery = query
    insertQuery[kSecValueData] = data
    insertQuery[kSecAttrAccessControl] = access
    insertQuery[kSecUseAuthenticationContext] = context

    let status = SecItemAdd(insertQuery as CFDictionary, nil)
    if status == errSecSuccess {
      return
    }
    reject(PrivateKeyStorageErrors.store(status.description).localizedDescription, PrivateKeyStorageErrors.store(status.description).failureReason, nil)
  }

  @objc func savePrivateKey(_ accountId: String, base64Key: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    authenticate(reason: localized(key: "AUTH_SAVE_PRIVATE_KEY", value: "Authenticate to store your private key"), onSuccess: { context in
      guard let data = Data(base64Encoded: base64Key) else {
        reject(PrivateKeyStorageErrors.invalidData.localizedDescription, PrivateKeyStorageErrors.invalidData.failureReason, nil)
        return
      }

      self.saveData(accountId: accountId, data: data, context: context, reject: reject)
      self.updateAccountIds(add: accountId, remove: nil)

      resolve(nil)
    }, onFailure: reject)
  }
  
  @objc func savePrivateKeys(_ privateKeys: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    authenticate(reason: localized(key: "AUTH_SAVE_PRIVATE_KEYS", value: "Authenticate to store your private keys"), onSuccess: { context in
      for (key, value) in privateKeys {
        guard let accountId = key as? String,
              let base64 = value as? String,
              let data = Data(base64Encoded: base64) else {
          reject(PrivateKeyStorageErrors.invalidData.localizedDescription, PrivateKeyStorageErrors.invalidData.failureReason, nil)
          return
        }

        self.saveData(accountId: accountId, data: data, context: context, reject: reject)
        self.updateAccountIds(add: accountId, remove: nil)
      }

      resolve(nil)
    }, onFailure: reject)
  }
}
