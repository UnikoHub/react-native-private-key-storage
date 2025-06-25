import React

extension Bundle {
  static var privateKeyStorageBundle: Bundle {
      return Bundle(for: PrivateKeyStorageImpl.self)
  }
}

public func localized(key: String, value: String) -> String {
  return NSLocalizedString(key, tableName: "PrivateKeyStorage", bundle: Bundle.privateKeyStorageBundle, comment: "")
}
