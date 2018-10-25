package com.hahafather007.flutterweather.utils

/**
 * Created by chenpengxiang on 2018/6/15
 */

/**
 * 检查List是否有效
 */
fun <T> List<T?>?.isValid() = this != null && this.isNotEmpty()

/**
 * 提取List所有有效数据
 */
fun <T> List<T?>?.validData(): List<T> {
    if (this == null) return emptyList()

    val list = mutableListOf<T>()
    this.forEach {
        if (it != null) {
            list.add(it)
        }
    }

    return list.toList()
}

/**
 * 检查String是否有效
 */
fun String?.isValid() = this != null && this.isNotEmpty() && this.isNotBlank()

