package com.hahafather007.flutterweather.view.activity

import android.os.Bundle
import com.hahafather007.flutterweather.utils.*
import com.hahafather007.flutterweather.viewmodel.MainViewModel
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.Observable
import io.reactivex.disposables.CompositeDisposable

class MainActivity : FlutterActivity(), RxController {
    override val rxComposite = CompositeDisposable()

    private val viewModel = MainViewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        initChannel()
        deleteOldApk()
    }

    override fun onDestroy() {
        super.onDestroy()

        dispose()
        viewModel.dispose()
    }

    private fun initChannel() {
        MethodChannel(flutterView, CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                START_LOCATION -> {
                    viewModel.getLocation(result)
                }
                SEND_EMAIL -> {
                    result.success(ConnectUtil.sendEmail(this,
                            email = call.argument("email")!!))
                }
                DOWNLOAD_APK -> {
                    downloadApk(call.argument("url")!!, call.argument("verCode")!!,
                            call.argument("isWifi")!!, result)
                }
                INSTALL_APK -> {
                    UpdateUtil.installApk(this, call.argument("verCode")!!)

                    result.success(true)
                }
                else ->
                    result.notImplemented()
            }
        }
    }

    /**
     * 下载APK更新包
     */
    private fun downloadApk(url: String, verCode: Int, isWifi: Boolean, result: MethodChannel.Result) {
        if (UpdateUtil.isApkExist(this, verCode)) {
            result.success(true)
        } else {
            if (!isWifi) return

            Observable.just(verCode)
                    .map {
                        UpdateUtil.downloadApk(this, url, it)
                        it
                    }
                    .disposable(this)
                    .asyncSwitch()
                    .doOnNext {
                        result.success(true)
                    }
                    .doOnError {
                        result.success(false)
                    }
                    .subscribe()
        }
    }

    /**
     * 删除旧安装包
     */
    private fun deleteOldApk() {
        Observable.just(1)
                .map {
                    UpdateUtil.deleteOldApk(this)
                }
                .disposable(this)
                .asyncSwitch()
                .subscribe()
    }

    companion object {
        /**
         * Channel通道的名字
         */
        private const val CHANNEL_NAME = "flutter_weather_channel"

        /**
         * 开始定位
         */
        private const val START_LOCATION = "weatherStartLocation"
        private const val SEND_EMAIL = "weatherSendEmail"
        private const val DOWNLOAD_APK = "weatherDownloadApk"
        private const val INSTALL_APK = "weatherInstallApk"
    }
}

