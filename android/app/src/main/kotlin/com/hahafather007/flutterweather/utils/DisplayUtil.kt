package com.hahafather007.flutterweather.utils

import android.app.Fragment
import android.content.Context
import android.util.TypedValue

/**
 * Created by chenpengxiang on 2018/6/15
 */

private fun Context.applyDimensionPixelSize(value: Float, unit: Int) =
        TypedValue.applyDimension(unit, value, this.resources.displayMetrics).toInt()

/**
 * @param value 将value的dp值转化为px
 */
fun Context.dp2px(value: Float) =
        applyDimensionPixelSize(value, TypedValue.COMPLEX_UNIT_DIP)

/**
 * @param value 将value的sp值转化为px
 */
fun Context.sp2px(value: Float) =
        applyDimensionPixelSize(value, TypedValue.COMPLEX_UNIT_SP)

/**
 * @param value 将value的dp值转化为px
 */
fun Fragment.dp2px(value: Float) =
        this.activity?.applyDimensionPixelSize(value, TypedValue.COMPLEX_UNIT_DIP) ?: 0

/**
 * @param value 将value的sp值转化为px
 */
fun Fragment.sp2px(value: Float) =
        this.activity?.applyDimensionPixelSize(value, TypedValue.COMPLEX_UNIT_SP) ?: 0

