import Foundation
import Security
import LocalAuthentication
import React

@objc(PrivateKeyStorageImpl)
public class PrivateKeyStorageImpl: NSObject {

  internal let service = "private_key_storage_service"
  internal let accountIdsKey = "private_key_storage_account_ids"

  @objc public override init() {
    super.init()
  }

  internal func authenticate(reason: String, onSuccess: @escaping (LAContext) -> Void, onFailure: @escaping RCTPromiseRejectBlock) {
    let context = LAContext()
    context.localizedReason = reason
    context.localizedFallbackTitle = localized(key: "AUTH_USE_PASSCODE", value: "Use Passcode")
    context.localizedCancelTitle = localized(key: "AUTH_CANCEL", value: "Cancel")

    var error: NSError?
    guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
      onFailure(PrivateKeyStorageErrors.biometricUnavailable(error?.localizedDescription).localizedDescription,
                 PrivateKeyStorageErrors.biometricUnavailable(error?.localizedDescription).failureReason, error)
      return
    }

    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: context.localizedReason) { success, authError in
      if success {
        onSuccess(context)
        return
      }
      onFailure(PrivateKeyStorageErrors.auth(authError?.localizedDescription).localizedDescription,
                 PrivateKeyStorageErrors.auth(authError?.localizedDescription).failureReason, authError)
    }
  }

  internal func readAccountIds() -> [String] {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accountIdsKey,
      kSecReturnData: true
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data,
          let str = String(data: data, encoding: .utf8) else {
      return []
    }

    return str.split(separator: ",").map(String.init)
  }

  internal func saveAccountIds(_ list: [String]) {
    let joined = list.joined(separator: ",")
    let data = joined.data(using: .utf8)!

    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accountIdsKey
    ]
    SecItemDelete(query as CFDictionary)

    var insertQuery = query
    insertQuery[kSecValueData] = data
    SecItemAdd(insertQuery as CFDictionary, nil)
  }

  internal func updateAccountIds(add: String?, remove: String?) {
    var accountIds = self.readAccountIds()
    if let addAccountId = add, !accountIds.contains(addAccountId) { accountIds.append(addAccountId) }
    if let removeAccountId = remove { accountIds.removeAll { $0 == removeAccountId } }
    self.saveAccountIds(accountIds)
  }
}
