package com.hahafather007.flutterweather.utils

import android.annotation.TargetApi
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import android.support.v4.app.NotificationCompat
import android.support.v4.app.NotificationCompat.FLAG_ONLY_ALERT_ONCE
import android.support.v4.app.NotificationCompat.PRIORITY_DEFAULT
import com.hahafather007.flutterweather.R

class NotificationUtil(private val context: Context) {
    private val manager: NotificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    init {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel()
        }
    }

    @TargetApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel() {
        val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT)
        channel.enableLights(true)
        channel.enableVibration(false)
        channel.vibrationPattern = longArrayOf(0)
        channel.setSound(null, null)
        manager.createNotificationChannel(channel)
    }

    /**
     * 发送通知
     */
    fun sendNotification(title: String, content: String) {
        val builder = getNotification(title, content)
        manager.notify(888, builder.build())
    }

    private fun getNotification(title: String, content: String): NotificationCompat.Builder {
        val builder: NotificationCompat.Builder
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder = NotificationCompat.Builder(context.applicationContext, CHANNEL_ID)
        } else {
            builder = NotificationCompat.Builder(context.applicationContext)
            builder.priority = PRIORITY_DEFAULT
        }
        builder.setContentTitle(title)
                .setContentText(content)
                .setSmallIcon(R.mipmap.ic_launcher)

        return builder
    }

    /**
     * 发送通知
     */
    fun sendNotification(notifyId: Int, title: String, content: String) {
        val builder = getNotification(title, content)
        manager.notify(notifyId, builder.build())
    }

    /**
     * 发送带有进度的通知
     */
    fun sendNotificationProgress(title: String, content: String, progress: Int, intent: PendingIntent?) {
        val builder = getNotificationProgress(title, content, progress, intent)
        if (progress >= 100) {
            manager.cancel(666)
        }
        manager.notify(666, builder.build())
    }

    /**
     * 获取带有进度的Notification
     */
    private fun getNotificationProgress(title: String, content: String,
                                        progress: Int, intent: PendingIntent?): NotificationCompat.Builder {
        val builder: NotificationCompat.Builder
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder = NotificationCompat.Builder(context.applicationContext, CHANNEL_ID)
        } else {
            builder = NotificationCompat.Builder(context.applicationContext)
            builder.priority = PRIORITY_DEFAULT
        }
        builder.setContentTitle(title)
                .setContentText(content)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setLargeIcon(BitmapFactory.decodeResource(context.resources, R.mipmap.ic_launcher))
                .setDefaults(FLAG_ONLY_ALERT_ONCE)
                .setWhen(System.currentTimeMillis())
                .setSound(null)
                .setVibrate(longArrayOf(0))

        if (progress <= 99) {
            //一种是有进度刻度的（false）,一种是循环流动的（true）
            //设置为false，表示刻度，设置为true，表示流动
            builder.setProgress(100, progress, false)
        } else {
            //0,0,false,可以将进度条隐藏
            builder.setProgress(0, 0, false)
        }

        if (intent != null) {
            builder.setContentIntent(intent)
        }

        return builder
    }

    companion object {
        private const val CHANNEL_ID = "default"
        private const val CHANNEL_NAME = "weatherDefaultChannel"
    }
}
