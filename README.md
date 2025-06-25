# 🔐 react-native-private-key-storage

**Securely store private keys in React Native** using Android Keystore and iOS Secure Enclave.  
Supports Face ID, Touch ID, device passcode fallback (PIN/password), and automatic biometric prompts.

Designed for crypto wallets, authentication tokens, and other sensitive key material.

---

## ✅ Features

- 📱 Biometric protection via **Face ID / Touch ID / PIN / Passcode**
- 🔐 **Encrypted DataStore (Android)** with AES256-GCM secure key management
- 🧠 No need to handle key encryption manually — just store and retrieve
- ✨ Zero-dependency API for React Native (TurboModule-based)
- ☁️ Fully local — no network or server interaction
- 🔡 Suitable for **production crypto apps**, wallet apps, identity/auth flows

---

## 📦 Installation

```sh
npm install react-native-private-key-storage
```

or

```sh
yarn add react-native-private-key-storage
```

### Android Setup

No additional setup required — biometric and secure storage are included automatically.

Make sure your `build.gradle` (project-level) has:

```gradle
minSdkVersion = 23
```

---

## 🧑‍💻 Usage

### 1. Import the module

```ts
import PrivateKeyStorage from 'react-native-private-key-storage';
```

### 2. Save a key

```ts
await PrivateKeyStorage.savePrivateKey('account1', base64PrivateKey);
```

> Will prompt biometric auth with system fallback (Face ID / PIN / password)

### 3. Get a key

```ts
const key = await PrivateKeyStorage.getPrivateKey('account1');
```

### 4. Delete a key

```ts
await PrivateKeyStorage.deletePrivateKey('account1');
```

### 5. Store or retrieve multiple keys

```ts
// Save many
await PrivateKeyStorage.savePrivateKeys({
  account1: base64Key1,
  account2: base64Key2,
});

// Get all
const allKeys = await PrivateKeyStorage.getPrivateKeys(); // returns Record<string, string>

// Delete all
await PrivateKeyStorage.deletePrivateKeys();
```

---

## 🔐 Security Notes

- Android uses **Encrypted DataStore** with **biometric prompt via BiometricPrompt**
- iOS uses **Secure Enclave + Face ID / Touch ID / Passcode**
- All access is gated through system-native biometric dialog

---

## 🤝 Contributing

We welcome issues and PRs! See [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 📄 License

MIT

---

> Built with ❤️ using [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

