package com.hahafather007.flutterweather.utils

import io.reactivex.disposables.CompositeDisposable

/**
 * Created by chenpengxiang on 2018/6/15
 */

interface RxController {
    /**
     * 在子类中这样写：
     * override val rxComposite = CompositeDisposable()
     */
    val rxComposite: CompositeDisposable

    /**
     * 继承的子类在activity销毁时调用该方法释放资源
     */
    fun dispose() {
        rxComposite.clear()
    }
}