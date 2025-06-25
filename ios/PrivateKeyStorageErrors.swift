import Foundation

public enum PrivateKeyStorageErrors: Error {
  case invalidData
  case accessControl(String?)
  case store(String?)
  case notFound(String?)
  case delete(String?)
  case auth(String?)
  case biometricUnavailable(String?)
}

extension PrivateKeyStorageErrors: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidData:
      return "INVALID_DATA_ERROR"
    case .accessControl(_):
      return "ACCESS_CONTROL_ERROR"
    case .store(_):
      return "STORE_ERROR"
    case .notFound(_):
      return "NOT_FOUND_ERROR"
    case .delete(_):
      return "DELETE_ERROR"
    case .auth(_):
      return "AUTH_ERROR"
    case .biometricUnavailable(_):
      return "BIOMETRIC_UNAVAILABLE_ERROR"
    }
  }
  public var failureReason: String? {
    switch self {
    case .invalidData:
      return localized(key: "INVALID_DATA_ERROR", value: "Invalid base64 data provided for the private key.")
    case .accessControl(let message):
      let format = localized(key: "ACCESS_CONTROL_ERROR", value: "Failed to create access control for the private key: %@")
      return String(format: format, message ?? "Unknown error")
    case .store(let message):
      let format = localized(key: "STORE_ERROR", value: "Failed to store the private key: %@")
      return String(format: format, message ?? "Unknown error")
    case .notFound(let message):
      let format = localized(key: "NOT_FOUND_ERROR", value: "Private key not found: %@")
      return String(format: format, message ?? "Unknown error")
    case .delete(let message):
      let format = localized(key: "DELETE_ERROR", value: "Failed to delete the private key: %@")
      return String(format: format, message ?? "Unknown error")
    case .auth(let message):
      let format = localized(key: "AUTH_ERROR", value: "Authentication failed: %@")
      return String(format: format, message ?? "Unknown error")
    case .biometricUnavailable(let message):
      let format = localized(key: "BIOMETRIC_UNAVAILABLE_ERROR", value: "Biometric authentication is not available: %@")
      return String(format: format, message ?? "Unknown error")
    }
  }
}
