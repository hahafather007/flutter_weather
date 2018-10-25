package com.hahafather007.flutterweather.view.activity

import android.Manifest.permission.*
import android.os.Bundle
import com.hahafather007.flutterweather.utils.RxController
import com.hahafather007.flutterweather.utils.disposable
import com.hahafather007.flutterweather.view.activity.ChannelTag.CHANNEL_NAME
import com.hahafather007.flutterweather.view.activity.ChannelTag.START_LOCATION
import com.hahafather007.flutterweather.viewmodel.MainViewModel
import com.tbruyelle.rxpermissions2.RxPermissions

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.disposables.CompositeDisposable

class MainActivity : FlutterActivity(), RxController {
    override val rxComposite = CompositeDisposable()

    private val viewModel = MainViewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        initChannel()
    }

    override fun onDestroy() {
        super.onDestroy()

        dispose()
        viewModel.dispose()
    }

    private fun initChannel() {
        MethodChannel(flutterView, CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                START_LOCATION -> getLocation(result)
                else ->
                    result.notImplemented()
            }
        }
    }

    private fun getLocation(result: MethodChannel.Result) {
        RxPermissions(this)
                .request(ACCESS_FINE_LOCATION)
                .disposable(this)
                .doOnNext {
                    viewModel.getLocation(result)
                }
                .subscribe()
    }
}

object ChannelTag {
    /**
     * Channel通道的名字
     */
    const val CHANNEL_NAME = "flutter_weather_channel"

    /**
     * 开始定位
     */
    const val START_LOCATION = "startLocation"
}