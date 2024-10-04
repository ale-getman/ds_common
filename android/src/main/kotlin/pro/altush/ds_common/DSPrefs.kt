package pro.altush.ds_common

import android.content.Context
import android.content.SharedPreferences

class DSPrefs {
    companion object {
        fun getFlutterPreferences(context: Context): SharedPreferences {
            return context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        }
    }
}