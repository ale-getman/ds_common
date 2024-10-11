package pro.altush.ds_common

import android.util.Log
import com.google.firebase.crashlytics.FirebaseCrashlytics
//import com.google.firebase.crashlytics.ktx.setCustomKeys
import io.appmetrica.analytics.AppMetrica
import timber.log.Timber

class DSReleaseTree : Timber.Tree() {

    override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
        // Don't log VERBOSE, DEBUG and INFO

        if (priority >= Log.WARN) {
            val e = t ?: Exception(message)

            val crashlytics = FirebaseCrashlytics.getInstance()
//            crashlytics.setCustomKeys {
//                key("priority", priority)
//                key("tag", tag ?: "")
//                key("message", message)
//            }
            crashlytics.recordException(e)
            AppMetrica.reportError(message, e)
        }
    }

}