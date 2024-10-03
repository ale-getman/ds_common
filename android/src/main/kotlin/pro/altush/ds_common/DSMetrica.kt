import android.content.Context
import android.util.Log
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry

import com.yandex.metrica.YandexMetrica
import com.yandex.metrica.YandexMetricaConfig

class DSMetrica {
    companion object {
        fun init(app: FlutterApplication, metricaKey: String) {
            val config: YandexMetricaConfig =
                YandexMetricaConfig.newConfigBuilder(metricaKey).withLocationTracking(false).build()
            YandexMetrica.activate(app.applicationContext, config)
            YandexMetrica.enableActivityAutoTracking(app)
        }
    }
}