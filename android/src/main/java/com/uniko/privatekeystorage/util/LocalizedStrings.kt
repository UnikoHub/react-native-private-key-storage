package com.uniko.privatekeystorage.util

import android.content.Context

object LocalizedStrings {
    fun of(context: Context, keyResId: Int, vararg args: Any?): String {
        return context.getString(keyResId, *args)
    }
}
