package com.hahafather007.flutterweather.utils

import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.schedulers.Schedulers

/**
 * Created by chenpengxiang on 2018/6/15
 */

/**
 * 用于异步线程和主线程切换
 */
fun <T> Observable<T>.asyncSwitch() = this.ioSub().uiObs()

/**
 * 用于定时器或循环器等情况切换线程
 */
fun <T> Observable<T>.computeSwitch() = this.cmpSub().uiObs()

/**
 * 在IO线程订阅
 */
fun <T> Observable<T>.ioSub() =
    this.subscribeOn(Schedulers.io())

/**
 * 在主线程观察
 */
fun <T> Observable<T>.uiObs() =
    this.observeOn(AndroidSchedulers.mainThread())

/**
 * 在计算线程订阅
 */
fun <T> Observable<T>.cmpSub() =
    this.subscribeOn(Schedulers.computation())

/**
 * @param loading 传入一个ObservableBoolean值，在加载时自动改变状态
 */
//fun <T, B : ObservableBoolean> Observable<T>.status(loading: B) =
//    this.doOnSubscribe { loading.set(true) }
//        .doFinally { loading.set(false) }


/**
 * @param composite 传入CompositeDisposable对象对Observable进行统一管理
 */
fun <T, C : RxController> Observable<T>.disposable(controller: C): Observable<T> {
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