package pro.altush.ds_common

import android.app.Activity
import android.content.Context
import io.flutter.app.FlutterApplication

import io.appmetrica.analytics.AppMetrica;
import io.appmetrica.analytics.AppMetricaConfig
import timber.log.Timber

class DSMetrica {
    companion object {
        private var isInitialized = false
        private var contextCallback: (() -> Context)? = null
        private var reportEventError = false

        fun init(app: FlutterApplication, metricaKey: String) {
            if (isInitialized) {
                Timber.e("DSMetrica is already initialised (native)")
            }
            isInitialized = true
            contextCallback = { app.applicationContext }
            val config = AppMetricaConfig.newConfigBuilder(metricaKey)
            if (BuildConfig.DEBUG) {
                config.withSessionsAutoTrackingEnabled(false)
            }
            AppMetrica.activate(app.applicationContext, config.build())
            AppMetrica.enableActivityAutoTracking(app)
            if (BuildConfig.DEBUG) {
                AppMetrica.pauseSession(null)
            }
        }

        fun setApplicationContextCallback(callback: (() -> Context)?) {
            contextCallback = callback
        }

        fun reportAppOpen(activity: Activity) {
            Timber.d("DSMetrica: report app open")
            if (BuildConfig.DEBUG) return
            AppMetrica.reportAppOpen(activity)
        }

        fun reportEvent(eventName: String, attributes: Map<String, Any>? = null) {
            try {
                val context = contextCallback!!.invoke()
                val prefs = DSPrefs.getFlutterPreferences(context)
                val sessionId = prefs.getLong("flutter.app_session_id", 0)
                val attrs = mutableMapOf<String, Any>("session_id" to sessionId, "session_$sessionId" to true)
                attributes?.let {
                    attrs.putAll(it)
                }

//                Toast.makeText(context, "SCEvent: $eventName $attrs", Toast.LENGTH_SHORT).show()

                Timber.d("DSEventNative: $eventName $attrs")

                if (BuildConfig.DEBUG) return

                AppMetrica.reportEvent(eventName, attrs)
            } catch (e: Throwable) {
                if (!reportEventError) {
                    reportEventError = true
                    Timber.e(e)
                }
            }
        }
    }
}