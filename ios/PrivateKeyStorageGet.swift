import Foundation
import Security
import LocalAuthentication
import React

public extension PrivateKeyStorageImpl {
  private func getData(accountId: String, context: LAContext, reject: RCTPromiseRejectBlock?) -> String? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accountId,
      kSecReturnData: true,
      kSecUseAuthenticationContext: context
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecSuccess, let data = item as? Data {
      return data.base64EncodedString()
    }
    
    reject?(PrivateKeyStorageErrors.notFound(status.description).localizedDescription,
           PrivateKeyStorageErrors.notFound(status.description).failureReason, nil)
    return nil
  }

  @objc func getPrivateKey(_ accountId: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    authenticate(reason: localized(key: "AUTH_PRIVATE_KEY", value: "Authenticate to view your private key"), onSuccess: { context in
      guard let data = self.getData(accountId: accountId, context: context, reject: reject) else {
        return
      }

      resolve(data)
    }, onFailure: reject)
  }

  @objc func getPrivateKeys(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    authenticate(reason: localized(key: "AUTH_PRIVATE_KEYS", value: "Authenticate to view your private keys"), onSuccess: { context in
      let accountIds = self.readAccountIds()
      var result: [String: String] = [:]

      for accountId in accountIds {
        guard let data = self.getData(accountId: accountId, context: context, reject: nil) else {
          continue
        }

        result[accountId] = data
      }

      resolve(result)
    }, onFailure: reject)
  }
}
