package com.hahafather007.flutterweather.utils

import android.content.Context
import android.os.AsyncTask
import java.io.BufferedInputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL

class DownloadTask(context: Context, private val url: String, private val verCode: Int,
                   private val isQuiet: Boolean, private val listener: DownloadListener,
                   private val notifyUtil: NotificationUtil) : AsyncTask<String, Int, File?>() {
    private val dir = File("${context.filesDir.absolutePath}/apk_download")
    private var currentProcess = 0

    init {
        // 创建apk下载文件夹
        if (!dir.exists()) {
            dir.mkdir()
        }
    }

    override fun onPreExecute() {
        listener.onStart()
    }

    override fun doInBackground(vararg params: String?): File? {
        val file = File(dir, "$verCode.apk")
        if (file.exists()) {
            return file
        }
        try {
            var conn = getConnect(url)
            if (conn.responseCode == 302) {
                conn = getConnect(conn.headerFields["Location"]!!.first())
            }
            val inputStream = conn.inputStream
            val outputStream = FileOutputStream(file)
            val buff = BufferedInputStream(inputStream)
            val buffer = ByteArray(1024)
            var process = 0
            // 开始写入文件
            do {
                try {
                    val len = buff.read(buffer)
                    if (len == -1) {
                        break
                    } else {
                        outputStream.write(buffer, 0, len)
                        process += len

                        val value = process * 100 / conn.contentLength
                        if (value != currentProcess) {
                            currentProcess = value
                            publishProgress(currentProcess)
                        }
                    }
                } catch (e: IOException) {
                    e.printStackTrace()
                    outputStream.close()
                    inputStream.close()
                    buff.close()

                    if (file.exists()) {
                        file.delete()
                    }

                    return null
                }
            } while (true)

            outputStream.close()
            inputStream.close()
            buff.close()

            return file
        } catch (e: IOException) {
            return null
        }
    }

    private fun getConnect(url: String): HttpURLConnection {
        val conn = URL(url).openConnection() as HttpURLConnection
        conn.connectTimeout = 10000
        conn.readTimeout = 10000
        conn.setRequestProperty("Accept-Encoding", "identity")

        return conn
    }

    override fun onProgressUpdate(vararg values: Int?) {
        if (values.isEmpty() || isQuiet) return

        val value = values[0]
        if (value is Int && value <= 99) {
            notifyUtil.sendNotificationProgress("APK下载中...", "$value%",
                    value, null)
        }
    }

    override fun onPostExecute(result: File?) {
        if (result is File) {
            listener.onSuccess()
        } else {
            listener.onFail()
        }
    }

    override fun onCancelled() {
        listener.onFail()
    }
}

interface DownloadListener {
    fun onStart()
    fun onSuccess()
    fun onFail()
}