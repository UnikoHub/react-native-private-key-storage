package com.uniko.privatekeystorage.storage

import android.content.Context
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import org.json.JSONObject
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap

private val Context.dataStore by preferencesDataStore(name = "private_key_storage")

class PrivateKeyStorage(private val context: Context) {

    private val keysKey = stringPreferencesKey("private_keys_json")

    fun save(accountId: String, base64Key: String) = runBlocking {
      val current = loadAll()
      val updated = current.toMutableMap()
      updated[accountId] = base64Key
      saveAllToStore(updated)
    }

    fun saveAll(map: ReadableMap) = runBlocking {
      val data = mutableMapOf<String, String>()
      val keys = map.keySetIterator()
      while (keys.hasNextKey()) {
        val key = keys.nextKey()
        val value = map.getString(key)
        if (value != null) data[key] = value
      }
      
      val current = loadAll().toMutableMap()
      current.putAll(data)
      saveAllToStore(current)
    }

    fun get(accountId: String): String? = runBlocking {
      loadAll()[accountId]
    }

    fun getAll(): WritableMap = runBlocking {
      val data = loadAll()
      val map = Arguments.createMap()
      data.forEach { (key, value) ->
        map.putString(key, value)
      }
      map
    }
    
    fun delete(accountId: String) = runBlocking {
      val current = loadAll().toMutableMap()
      current.remove(accountId)
      saveAllToStore(current)
    }

    fun deleteAll() = runBlocking {
      context.dataStore.edit { prefs ->
        prefs.remove(keysKey)
      }
    }

    private suspend fun loadAll(): Map<String, String> {
      val prefs = context.dataStore.data.first()
      val jsonString = prefs[keysKey] ?: return emptyMap()

      return try {
        val json = JSONObject(jsonString)
        buildMap {
          val iterator = json.keys()
          while (iterator.hasNext()) {
            val key = iterator.next()
            put(key, json.getString(key))
          }
        }
      } catch (e: Exception) {
        emptyMap()
      }
    }

    private suspend fun saveAllToStore(map: Map<String, String>) {
      val json = JSONObject().apply {
        map.forEach { (k, v) -> put(k, v) }
      }.toString()

      context.dataStore.edit { prefs ->
        prefs[keysKey] = json
      }
    }
}
