package com.uniko.privatekeystorage.biometric

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import java.util.concurrent.Executor

class BiometricHelper(private val activity: FragmentActivity) {

    private val executor: Executor = ContextCompat.getMainExecutor(activity)

    fun authenticate(
        title: String,
        description: String,
        cancelButtonText: String = "Cancel",
        onSuccess: (BiometricPrompt.AuthenticationResult) -> Unit,
        onError: (Throwable) -> Unit
    ) {
        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle(title)
            .setDescription(description)
            .setAllowedAuthenticators(
                BiometricManager.Authenticators.BIOMETRIC_STRONG or
                BiometricManager.Authenticators.DEVICE_CREDENTIAL
            )
            .build()

        val prompt = BiometricPrompt(
            activity,
            executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    onSuccess(result)
                }

                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    onError(Throwable(errString.toString()))
                }

                override fun onAuthenticationFailed() {
                    onError(Throwable("Authentication failed"))
                }
            }
        )

        Handler(Looper.getMainLooper()).post {
            prompt.authenticate(promptInfo)
        }
    }

    companion object {
        fun isBiometricAvailable(context: Context): Boolean {
            return BiometricManager.from(context)
                .canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG) ==
                BiometricManager.BIOMETRIC_SUCCESS
        }
    }
}
