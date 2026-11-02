package com.yankeessoftware.mf_customer

import android.app.Activity
import android.content.Intent
import android.speech.RecognizerIntent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pending: MethodChannel.Result? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mf_customer/device").setMethodCallHandler { call, result ->
            if (pending != null) { result.error("busy", "Another picker is open", null); return@setMethodCallHandler }
            try {
                when (call.method) {
                    "pickPhoto" -> {
                        pending = result
                        val intent = Intent(Intent.ACTION_GET_CONTENT).apply { type = "image/*"; addCategory(Intent.CATEGORY_OPENABLE) }
                        startActivityForResult(intent, 201)
                    }
                    "transcribe" -> {
                        pending = result
                        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                            putExtra(RecognizerIntent.EXTRA_LANGUAGE, call.argument<String>("language"))
                            putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, true)
                        }
                        startActivityForResult(intent, 202)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) { pending = null; result.error("unavailable", e.message, null) }
        }
    }
    @Deprecated("Activity result bridge")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != 201 && requestCode != 202) return
        val result = pending ?: return
        pending = null
        if (resultCode != Activity.RESULT_OK) { result.success(null); return }
        try {
            if (requestCode == 201) {
                val uri = data?.data
                val bytes = uri?.let { contentResolver.openInputStream(it)?.use { stream -> val output = java.io.ByteArrayOutputStream()
                    val buffer = ByteArray(8192)
                    while (output.size() <= 8 * 1024 * 1024) {
                        val count = stream.read(buffer)
                        if (count < 0) break
                        output.write(buffer, 0, count)
                    }
                    output.toByteArray() } }
                if (bytes != null && bytes.size > 8 * 1024 * 1024) result.error("too_large", "Select an image under 8 MB", null)
                else result.success(bytes)
            } else result.success(data?.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)?.firstOrNull())
        } catch (e: Exception) { result.error("failed", e.message, null) }
    }
}
