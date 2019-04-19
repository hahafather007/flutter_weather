package com.hahafather007.flutterweather.model.holder

import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
import com.hahafather007.flutterweather.app.WeatherApp
import com.hahafather007.flutterweather.utils.logError
import com.hahafather007.flutterweather.utils.logInfo
import io.reactivex.subjects.PublishSubject
import io.reactivex.subjects.Subject

/**
 * 利用该类获取地理位置
 */
class LocationHolder {
    val location: Subject<String> = PublishSubject.create()

    private val client = AMapLocationClient(WeatherApp.appContext)

    init {
        val option = AMapLocationClientOption()

        client.setLocationListener {
            if (it != null) {
                // 0表示定位成功
                if (it.errorCode == 0) {
                    location.onNext(it.district)

                    "定位信息：$it".logInfo()
                } else {
                    "定位出错：${it.adCode}-->\n${it.errorInfo}".logError()

                    location.onNext("")
                }
            }
        }

        // 设置高精度模式
        option.locationMode = Hight_Accuracy
        option.isOnceLocation = true

        client.setLocationOption(option)
    }

    /**
     * 调用该方法开始定位
     */
    fun startLocation() {
        client.startLocation()
    }

    fun dispose() {
        client.onDestroy()
    }
}