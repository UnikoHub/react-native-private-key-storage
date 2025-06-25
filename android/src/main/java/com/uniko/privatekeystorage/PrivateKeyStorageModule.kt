package com.uniko.privatekeystorage

import android.app.Activity
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap
import com.uniko.privatekeystorage.biometric.BiometricHelper
import com.uniko.privatekeystorage.storage.PrivateKeyStorage
import com.uniko.privatekeystorage.util.LocalizedStrings
import androidx.fragment.app.FragmentActivity

@ReactModule(name = PrivateKeyStorageModule.NAME)
class PrivateKeyStorageModule(reactContext: ReactApplicationContext) :
  NativePrivateKeyStorageSpec(reactContext) {

  companion object {
    const val NAME = "PrivateKeyStorage"
  }

  private val storage = PrivateKeyStorage(reactContext)

  private fun requireActivity(): Activity {
    return reactApplicationContext.currentActivity ?: throw IllegalStateException("No current activity")
  }

  private fun auth(reasonResId: Int, promise: Promise, block: () -> Unit) {
    val activity = reactApplicationContext.currentActivity as? FragmentActivity ?: run {
        promise.reject("NO_ACTIVITY", "Current activity is not a FragmentActivity.")
        return
    }
    val reason = LocalizedStrings.of(activity, reasonResId)
    val description = LocalizedStrings.of(activity, R.string.auth_description)

    BiometricHelper(activity).authenticate(
      title = reason,
      description = description,
      cancelButtonText = LocalizedStrings.of(activity, R.string.auth_cancel_button),
      onSuccess = { block() },
      onError = { e ->
        val message = LocalizedStrings.of(activity, R.string.auth_failed, e.message ?: "")
        promise.reject("AUTH_FAILED", message, e)
      }
    )
  }

  override fun savePrivateKey(accountId: String, base64Key: String, promise: Promise) {
    auth(R.string.auth_save_private_key, promise) {
      storage.save(accountId, base64Key)
      promise.resolve(null)
    }
  }

  override fun savePrivateKeys(privateKeys: ReadableMap, promise: Promise) {
    auth(R.string.auth_save_private_keys, promise) {
      storage.saveAll(privateKeys)
      promise.resolve(null)
    }
  }

  override fun getPrivateKey(accountId: String, promise: Promise) {
    val activity = requireActivity()
    auth(R.string.auth_view_private_key, promise) {
      val result = storage.get(accountId)
      if (result != null) promise.resolve(result)
      else promise.reject("NOT_FOUND", LocalizedStrings.of(activity, R.string.key_not_found, accountId))
    }
  }

  override fun getPrivateKeys(promise: Promise) {
    auth(R.string.auth_view_private_keys, promise) {
      promise.resolve(storage.getAll())
    }
  }

  override fun deletePrivateKey(accountId: String, promise: Promise) {
    auth(R.string.auth_delete_private_key, promise) {
      storage.delete(accountId)
      promise.resolve(null)
    }
  }

  override fun deletePrivateKeys(promise: Promise) {
    auth(R.string.auth_delete_private_keys, promise) {
      storage.deleteAll()
      promise.resolve(null)
    }
  }
}
