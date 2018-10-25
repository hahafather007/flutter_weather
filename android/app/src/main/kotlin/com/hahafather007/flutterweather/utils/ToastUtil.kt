package com.hahafather007.flutterweather.utils

import android.content.Context
import android.widget.Toast

/**
 * Created by chenpengxiang on 2018/6/14
 */

/**
 * 调用该方法弹出Toast
 *
 * @param msg 需要显示的文字
 * @param length Toast的显示属性
 */
fun <T> Context.showToast(msg: T?, length: Int = Toast.LENGTH_SHORT) {
    synchronized(this) {
        ToastUtil.showToast(this, msg?.toString() ?: "null", length)
    }
}

private object ToastUtil {
    private var toast: Toast? = null

    @JvmStatic
    fun showToast(context: Context, msg: String, length: Int) {
        synchronized(this) {
            toast?.cancel()
            toast = Toast.makeText(context, msg, length)
            toast?.show()
        }
    }
}