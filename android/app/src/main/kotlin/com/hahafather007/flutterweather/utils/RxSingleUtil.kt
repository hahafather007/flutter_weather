package com.hahafather007.weplus.utils

import com.hahafather007.flutterweather.utils.RxController
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.schedulers.Schedulers

/**
 * Created by chenpengxiang on 2018/6/15
 */

/**
 * 用于异步线程和主线程切换
 */
fun <T> Single<T>.asyncSwitch() = this.ioSub().uiObs()

/**
 * 用于定时器或循环器等情况切换线程
 */
fun <T> Single<T>.computeSwitch() = this.cmpSub().uiObs()

/**
 * 在IO线程订阅
 */
fun <T> Single<T>.ioSub() =
    this.subscribeOn(Schedulers.io())

/**
 * 在主线程观察
 */
fun <T> Single<T>.uiObs() =
    this.observeOn(AndroidSchedulers.mainThread())

/**
 * 在计算线程订阅
 */
fun <T> Single<T>.cmpSub() =
    this.subscribeOn(Schedulers.computation())

/**
 * @param loading 传入一个ObservableBoolean值，在加载时自动改变状态
 */
//fun <T, B : ObservableBoolean> Single<T>.status(loading: B) =
//    this.doOnSubscribe { loading.set(true) }
//        .doFinally { loading.set(false) }

/**
 * @param composite 传入CompositeDisposable对象对Observable进行统一管理，防止内存泄漏的发送
 */
fun <T, C : RxController> Single<T>.disposable(controller: C): Single<T> {
    var disposable: Disposable? = null

    return this.doOnSubscribe {
        disposable = it
        controller.rxComposite.add(it)
    }
        .doFinally {
            disposable?.apply {
                controller.rxComposite.remove(this)
            }
        }
}