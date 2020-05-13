import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/utils/log_util.dart';

export 'package:flutter_weather/common/streams.dart'
    show SubscriptionExt, ControllerExt;

abstract class ViewModel extends StreamSubController {
  final isLoading = StreamController<bool>();
  final error = StreamController<bool>();

  /// 内部判断是否加载数据的标识
  @protected
  bool selfLoading = false;

  /// 内部多种加载方式的标识
  @protected
  LoadType selfLoadType = LoadType.NEW_LOAD;

  /// 调用该方法释放内存
  void dispose() {
    isLoading.close();
    error.close();

    subDispose();
  }

  void doError(DioError e) {
    if (CancelToken.isCancel(e)) return;

    debugLog(e.message);
    debugLog(e.response.toString());

    error.safeAdd(true);
  }

  void reload() {}

  void loadMore() {}
}

/// 加载数据的状态
enum LoadType {
  /// 新加载
  NEW_LOAD,

  /// 刷新
  REFRESH,

  /// 加载更多
  LOAD_MORE,

  /// 到底了
  NO_MORE,
}
