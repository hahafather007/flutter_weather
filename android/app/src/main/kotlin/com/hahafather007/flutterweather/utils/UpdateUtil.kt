package com.hahafather007.flutterweather.utils

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.support.v4.content.FileProvider
import java.io.BufferedInputStream
import java.io.File
import java.io.FileOutputStream
import java.net.HttpURLConnection
import java.net.URL

object UpdateUtil {
    /**
     * 下载apk
     */
    fun downloadApk(context: Context, url: String, verCode: Int): File? {
        // 创建apk下载文件夹
        val dir = File("${context.filesDir.absolutePath}/apk_download")
        if (!dir.exists()) {
            dir.mkdir()
        }
        val file = File(dir, "$verCode.apk")
        if (file.exists()) {
            return file
        }
        val conn = URL(url).openConnection() as HttpURLConnection
        conn.connectTimeout = 5000
        conn.setRequestProperty("Accept-Encoding", "identity")
        val inputStream = conn.inputStream
        val outputStream = FileOutputStream(file)
        val buff = BufferedInputStream(inputStream)
        val buffer = ByteArray(1024)
        // 开始写入文件
        do {
            val len = buff.read(buffer)
            if (len == -1) {
                break
            } else {
                outputStream.write(buffer, 0, len)
            }
        } while (true)

        outputStream.close()
        inputStream.close()
        buff.close()

        return file
    }

    /**
     * 安装apk
     */
    fun installApk(context: Context, verCode: Int) {
        val file = File("${context.filesDir.absolutePath}/apk_download", "$verCode.apk")
        if (!file.exists()) return

        val intent = Intent()
        intent.action = Intent.ACTION_VIEW
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        val uri: Uri
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = FileProvider.getUriForFile(context,
                    "com.hahafather007.flutterweather.fileProvider", file)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

        } else {
            uri = Uri.fromFile(file)
        }

        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        context.startActivity(intent)
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
