package com.example.camara_playground

import android.Manifest
import android.content.pm.PackageManager
import android.telephony.TelephonyManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.camara_playground/device_phone_number",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDevicePhoneNumber" -> {
                    val hasReadPhoneNumbersPermission =
                        ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.READ_PHONE_NUMBERS,
                        ) == PackageManager.PERMISSION_GRANTED

                    val hasReadPhoneStatePermission =
                        ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.READ_PHONE_STATE,
                        ) == PackageManager.PERMISSION_GRANTED

                    if (!hasReadPhoneNumbersPermission && !hasReadPhoneStatePermission) {
                        result.error(
                            "NO_PERMISSION",
                            "READ_PHONE_NUMBERS or READ_PHONE_STATE not granted",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    val telephonyManager =
                        getSystemService(TELEPHONY_SERVICE) as TelephonyManager
                    val line1Number = telephonyManager.line1Number

                    if (line1Number.isNullOrEmpty()) {
                        result.success(null)
                    } else {
                        result.success(line1Number)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
