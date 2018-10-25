package com.hahafather007.flutterweather.viewmodel

import com.hahafather007.flutterweather.model.holder.LocationHolder
import com.hahafather007.flutterweather.utils.RxController
import com.hahafather007.flutterweather.utils.disposable
import io.flutter.plugin.common.MethodChannel
import io.reactivex.disposables.CompositeDisposable

class MainViewModel : RxController {
    override val rxComposite = CompositeDisposable()

    private val locationHolder = LocationHolder()
    private var locationResult: MethodChannel.Result? = null

    init {
        locationHolder.loaction
                .disposable(this)
                .doOnNext {
                    locationResult?.success(it)
                }
                .subscribe()
    }

    fun getLocation(result: MethodChannel.Result) {
        locationResult = result
        locationHolder.startLocation()
    }

    override fun dispose() {
        super.dispose()

        locationHolder.dispose()
    }
}