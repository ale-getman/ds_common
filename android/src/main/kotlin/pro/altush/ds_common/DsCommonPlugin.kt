package pro.altush.ds_common

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import pro.userx.UserX

/** DsCommonPlugin */
class DsCommonPlugin: FlutterPlugin {

    private val channeMetricaName = "pro.altush.ds_common/metrica"
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channeMetricaName)
        channel.setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            try {
                val context = flutterPluginBinding.applicationContext
                when (call.method) {
                    "setUserXScreenName" -> {
                        val name = call.arguments as String
                        UserX.addScreenName(name)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Throwable) {
                result.error("", "$e", null)
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
