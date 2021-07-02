package com.example.flutter_applovin

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.lang.Exception
import com.applovin.sdk.AppLovinMediationProvider
import com.applovin.sdk.AppLovinSdk
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterApplovinPlugin */
class FlutterApplovinPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var rewardInstance: RewardedVideo
    companion object {
        lateinit var activity: Activity
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding.platformViewRegistry.registerViewFactory("AppLovinBanner", AppBannerFactory())
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_applovin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> {
                try {
                    val args = call.arguments as Map<*, *>
                    val unitId = args["unitId"].toString()
                    appLovinInit(unitId, result)
                } catch (e: Exception) {
                    //
                }
            }
            "showRewardVideo" -> {
                rewardInstance.show()
                result.success(true)
            }
            "isLoaded" -> {
                result.success(rewardInstance.isLoaded())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun appLovinInit(unitId: String, @NonNull result: Result) {
        AppLovinSdk.getInstance(activity).mediationProvider = AppLovinMediationProvider.MAX
        AppLovinSdk.getInstance(activity).initializeSdk {
            rewardInstance = RewardedVideo(unitId, this)
            result.success(true)
        }
//        result.success(true)
    }

    fun callback(method: String, arguments: Map<String, *>) {
        FlutterApplovinPlugin.activity.runOnUiThread( Runnable {
            kotlin.run {
                this.channel.invokeMethod(method, arguments)
            }
        })
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        FlutterApplovinPlugin.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        FlutterApplovinPlugin.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
    }
}
