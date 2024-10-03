package pro.altush.ds_common

import timber.log.Timber

class DSTimber {
    companion object {
        fun init() {
            if (BuildConfig.DEBUG) {
                Timber.plant(DSReleaseTree())
                Timber.plant(DSDebugTree())
            } else {
                Timber.plant(DSReleaseTree())
            }
        }
    }
}