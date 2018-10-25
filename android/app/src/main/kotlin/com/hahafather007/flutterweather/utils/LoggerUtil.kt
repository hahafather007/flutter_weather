package com.hahafather007.flutterweather.utils

import android.util.Log


/**
 * Created by chenpengxiang on 2018/6/15
 */
private const val TAG = "--------------->"

fun Any?.logInfo(tag: String = "Info$TAG") {
    if (this == null) {
        Log.i(tag, "null")

        return
    }

    var msg = this.toString()

    val maxLength = 2001 - tag.length
    //大于4000时
    while (msg.length > maxLength) {
        Log.i(tag, msg.substring(0, maxLength))
        msg = msg.substring(maxLength)
    }
    //剩余部分
    Log.i(tag, msg)
}

fun Any?.logDebug(tag: String = "Debug$TAG") {
    if (this == null) {
        Log.d(tag, "null")

        return
    }

    var msg = this.toString()

    val maxLength = 2001 - tag.length
    //大于4000时
    while (msg.length > maxLength) {
        Log.d(tag, msg.substring(0, maxLength))
        msg = msg.substring(maxLength)
    }
    //剩余部分
    Log.d(tag, msg)
}

fun Any?.logWarn(tag: String = "Warn$TAG") {
    if (this == null) {
        Log.w(tag, "null")

        return
    }

    var msg = this.toString()

    val maxLength = 2001 - tag.length
    //大于4000时
    while (msg.length > maxLength) {
        Log.w(tag, msg.substring(0, maxLength))
        msg = msg.substring(maxLength)
    }
    //剩余部分
    Log.w(tag, msg)
}

fun Any?.logError(tag: String = "Error$TAG") {
    if (this == null) {
        Log.e(tag, "null")

        return
    }

    var msg = this.toString()

    val maxLength = 2001 - tag.length
    //大于4000时
    while (msg.length > maxLength) {
        Log.e(tag, msg.substring(0, maxLength))
        msg = msg.substring(maxLength)
    }
    //剩余部分
    Log.w(tag, msg)
}
