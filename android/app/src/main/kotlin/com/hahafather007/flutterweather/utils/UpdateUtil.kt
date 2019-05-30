package com.hahafather007.flutterweather.utils

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.support.v4.content.FileProvider
import java.io.File

object UpdateUtil {
    var task: DownloadTask? = null

    /**
     * 下载apk
     */
    fun downloadApk(context: Context, url: String, verCode: Int, isQuiet: Boolean,
                    listener: DownloadListener, notifyUtil: NotificationUtil) {
        if (task == null) {
            task = DownloadTask(context, url, verCode, isQuiet, listener, notifyUtil)
        }
        task?.execute()
    }

    fun cancelDownload() {
        task?.cancel(true)
        task = null
    }

    /**
     * 安装apk
     */
    fun installApk(context: Context, verCode: Int) {
        val intent = getInstallIntent(context, verCode)

        context.startActivity(intent)
    }

    fun getInstallIntent(context: Context, verCode: Int): Intent {
        val file = File("${context.filesDir.absolutePath}/apk_download", "$verCode.apk")

        val intent = Intent()
        intent.action = Intent.ACTION_VIEW
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        val uri: Uri
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = FileProvider.getUriForFile(context,
                    "com.g2game.scoreapp.fileProvider", file)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

        } else {
            uri = Uri.fromFile(file)
        }

        intent.setDataAndType(uri, "application/vnd.android.package-archive")

        return intent
    }

    /**
     * 判断新apk是否存在
     */
    fun isApkExist(context: Context, verCode: Int): Boolean {
        val file = File("${context.filesDir.absolutePath}/apk_download", "$verCode.apk")

        return file.exists()
    }

    /**
     * 删除旧安装包
     */
    fun deleteOldApk(context: Context) {
        val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
        val verCode = packageInfo.versionCode
        val path = "${context.filesDir.absolutePath}/apk_download"
        (0..verCode).forEach {
            val oldFile = File(path, "$it.apk")
            if (oldFile.exists()) {
                oldFile.delete()
            }
        }

    }
}
