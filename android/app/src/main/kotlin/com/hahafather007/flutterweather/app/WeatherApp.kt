package com.hahafather007.flutterweather.app

import android.content.Context
import io.flutter.app.FlutterApplication

class WeatherApp : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        appContext = this
    }

    override fun onTerminate() {
        super.onTerminate()

        appContext = null
    }

    companion object {
        var appContext: Context? = null
    }
}