package com.hahafather007.flutterweather.view.activity

import android.app.PendingIntent
import android.content.SharedPreferences
import android.os.Bundle
import com.hahafather007.flutterweather.utils.*
import com.hahafather007.flutterweather.viewmodel.MainViewModel
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.Observable
import io.reactivex.disposables.CompositeDisposable
import java.io.File

class MainActivity : FlutterActivity(), RxController {
    override val rxComposite = CompositeDisposable()

    private lateinit var sharePre: SharedPreferences

    private val viewModel = MainViewModel()
    private var isDownloading = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        GeneratedPluginRegistrant.registerWith(this)
        sharePre = getPreferences(MODE_PRIVATE)

        initChannel()
        deleteOldApk()
    }

    override fun onDestroy() {
        dispose()
        viewModel.dispose()
        UpdateUtil.cancelDownload()

        super.onDestroy()
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
                IS_DOWNLOADING -> {
                    result.success(isDownloading)
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
        UpdateUtil.cancelDownload()
        val notifyUtil = NotificationUtil(this)
        val pi = PendingIntent.getActivity(this, 0,
                UpdateUtil.getInstallIntent(this, verCode), PendingIntent.FLAG_CANCEL_CURRENT)


        if (sharePre.getBoolean("appVer$verCode", false)) {
            notifyUtil.sendNotificationProgress(
                    "APK下载完成", "点击安装", 100, pi)
            if (!isWifi) {
                UpdateUtil.installApk(this@MainActivity, verCode)
            }
            result.success(true)
        } else {
            val file = File("${filesDir.absolutePath}/apk_download/$verCode.apk")
            if (file.exists()) {
                file.delete()
            }

            UpdateUtil.downloadApk(this, url, verCode, isWifi, object : DownloadListener {
                override fun onStart() {
                    isDownloading = true
                }

                override fun onSuccess() {
                    isDownloading = false
                    result.success(true)
                    notifyUtil.sendNotificationProgress(
                            "APK下载完成", "点击安装", 100, pi)
                    if (!isWifi) {
                        UpdateUtil.installApk(this@MainActivity, verCode)
                    }
                    val edit = sharePre.edit()
                    edit.putBoolean("appVer$verCode", true)
                    edit.apply()
                }

                override fun onFail() {
                    isDownloading = false
                    result.success(false)
                    notifyUtil.sendNotificationProgress(
                            "APK下载失败", "请检查网络后重试！", 100, null)
                }
            }, notifyUtil)
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
        /**
         * 发送邮件
         */
        private const val SEND_EMAIL = "weatherSendEmail"
        /**
         * 下载APK
         */
        private const val DOWNLOAD_APK = "weatherDownloadApk"
        /**
         * 安装APK
         */
        private const val INSTALL_APK = "weatherInstallApk"
        /**
         * 判断是否正在下载APK
         */
        private const val IS_DOWNLOADING = "weatherIsDownloading"
    }
}

