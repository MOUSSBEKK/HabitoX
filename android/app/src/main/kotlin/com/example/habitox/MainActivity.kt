package com.example.habitox

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.habitox/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidget" -> {
                    try {
                        ActiveGoalHeatmapWidgetProvider.updateAllSync(this)
                        result.success("Widget mis à jour avec succès")
                    } catch (e: Exception) {
                        result.error("UPDATE_ERROR", "Erreur lors de la mise à jour du widget", e.message)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
