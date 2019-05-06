package com.hahafather007.flutterweather.utils

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.support.v4.content.ContextCompat.startActivity

object ConnectUtil {
    fun openQQ(context: Context, qqNum: String, groupKey: String?): Boolean {
        var result = false

        try {
            val uri = if (groupKey == null) {
                "mqqwpa://im/chat?chat_type=wpa&uin=$qqNum"
            } else {
                "mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm" +
                        "%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26k%3D$groupKey"
            }
            startActivity(context, Intent(Intent.ACTION_VIEW, Uri.parse(uri)), null)

            result = true
        } catch (e: ActivityNotFoundException) {
            e.printStackTrace()
        }

        return result
    }

    fun sendEmail(context: Context, email: String): Boolean {
        var result = false

        try {
            val intent = Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:$email"))
            intent.putExtra(Intent.EXTRA_CC, Array(1) { email })
            startActivity(context, Intent.createChooser(intent, "请选择邮件应用"), null)

            result = true
        } catch (e: ActivityNotFoundException) {
            e.printStackTrace()
        }

        return result
    }
}