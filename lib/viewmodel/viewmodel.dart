import 'package:flutter_weather/commom_import.dart';

abstract class ViewModel extends StreamSubController {
  final isLoading = StreamController<bool>();
  final error = StreamController<bool>();

  /// 内部判断是否加载数据的标识
  @protected
  bool selfLoading = false;

  /// 调用该方法释放内存
  void dispose() {
    isLoading.close();
    error.close();

    subDispose();
  }

  void doError(DioError e) {
    if (CancelToken.isCancel(e)) return;

    debugPrint(e.message);
    debugPrint(e.response.toString());

    error.add(true);
  }
}

/// 加载数据的状态
enum LoadType{
  /// 新加载
  NEW_LOAD,
  /// 刷新
  REFRESH,
  /// 加载更多
  LOAD_MORE,
}
