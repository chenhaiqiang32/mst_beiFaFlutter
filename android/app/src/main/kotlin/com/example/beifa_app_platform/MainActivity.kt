package com.example.beifa_app_platform

import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.beifa_app_platform/file"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        android.util.Log.d("MainActivity", "Configuring Flutter engine and setting up method channel: $CHANNEL")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            android.util.Log.d("MainActivity", "Method called: ${call.method}, arguments: ${call.arguments}")
            when (call.method) {
                "openFile" -> {
                    val filePath = call.argument<String>("filePath")
                    android.util.Log.d("MainActivity", "openFile called with path: $filePath")
                    if (filePath != null) {
                        openFile(filePath, result)
                    } else {
                        android.util.Log.e("MainActivity", "File path is null")
                        result.error("INVALID_ARGUMENT", "File path is null", null)
                    }
                }
                "installApk" -> {
                    val filePath = call.argument<String>("filePath")
                    android.util.Log.d("MainActivity", "installApk called with path: $filePath")
                    if (filePath != null) {
                        installApk(filePath, result)
                    } else {
                        android.util.Log.e("MainActivity", "File path is null")
                        result.error("INVALID_ARGUMENT", "File path is null", null)
                    }
                }
                else -> {
                    android.util.Log.e("MainActivity", "Unknown method: ${call.method}")
                    result.notImplemented()
                }
            }
        }
        android.util.Log.d("MainActivity", "Method channel handler registered successfully")
    }

    private fun openFile(filePath: String, result: MethodChannel.Result) {
        try {
            val file = File(filePath)
            if (!file.exists()) {
                result.error("FILE_NOT_FOUND", "File does not exist: $filePath", null)
                return
            }

            val uri = FileProvider.getUriForFile(
                this,
                "${applicationContext.packageName}.fileprovider",
                file
            )

            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, getMimeType(filePath))
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }

            if (intent.resolveActivity(packageManager) != null) {
                startActivity(intent)
                result.success(true)
            } else {
                result.error("NO_APP", "No app found to open file", null)
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to open file: ${e.message}", null)
        }
    }

    private fun installApk(filePath: String, result: MethodChannel.Result) {
        try {
            val file = File(filePath)
            if (!file.exists()) {
                result.error("FILE_NOT_FOUND", "File does not exist: $filePath", null)
                return
            }

            val uri = FileProvider.getUriForFile(
                this,
                "${applicationContext.packageName}.fileprovider",
                file
            )

            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, "application/vnd.android.package-archive")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }

            if (intent.resolveActivity(packageManager) != null) {
                startActivity(intent)
                result.success(true)
            } else {
                result.error("NO_APP", "No app found to install APK", null)
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to install APK: ${e.message}", null)
        }
    }

    private fun getMimeType(filePath: String): String {
        val extension = filePath.substringAfterLast('.', "").lowercase()
        return when (extension) {
            "apk" -> "application/vnd.android.package-archive"
            "pdf" -> "application/pdf"
            "txt" -> "text/plain"
            "jpg", "jpeg" -> "image/jpeg"
            "png" -> "image/png"
            else -> "*/*"
        }
    }
}
