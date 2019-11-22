import 'dart:async';

import 'package:flutter/material.dart';

/// 获取屏幕宽度
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

/// 获取屏幕高度
double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

/// 获取系统状态栏高度
double getStatusHeight(BuildContext context) {
  return 0;
}

double _appBarHeight = 0;
double _appBarHeightBottom = 0;

/// 获取标题栏高度
double getAppBarHeight({bool withBottom = false}) {
  if (withBottom) {
    if (_appBarHeightBottom != 0) {
      return _appBarHeightBottom;
    } else {
      final height =
          AppBar(bottom: const TabBar(tabs: const [])).preferredSize.height;
      _appBarHeightBottom = height;

      return _appBarHeightBottom;
    }
  } else {
    if (_appBarHeight != 0) {
      return _appBarHeight;
    } else {
      final height = AppBar().preferredSize.height;
      _appBarHeight = height;

      return _appBarHeight;
    }
  }
}

/// 关闭窗口
void pop(BuildContext context, {int count = 1, dynamic extraData}) {
  if (count == 1) {
    Navigator.pop(context, extraData);

    return;
  }

  for (int i = 0; i < count; i++) {
    Navigator.pop(context);
  }
}

/// 开启一个窗口
/// [replace] 是否代替当前界面
Future push<T extends Widget>(BuildContext context,
    {@required T page, bool replace = false}) {
  final route = MaterialPageRoute(builder: (_) => page);

  Future future;

  if (replace) {
    future = Navigator.of(context).pushReplacement(route);
  } else {
    future = Navigator.of(context).push(route);
  }

  return future;
}
