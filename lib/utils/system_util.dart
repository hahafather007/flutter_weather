import 'dart:async';

import 'package:flutter/material.dart';

double _screenWidth = 0;

/// 获取屏幕宽度
double getScreenWidth(BuildContext context) {
  if (_screenWidth != 0) {
    return _screenWidth;
  } else {
    final width = MediaQuery.of(context).size.width;
    _screenWidth = width;

    return _screenWidth;
  }
}

double _screenHeight = 0;

/// 获取屏幕高度
double getScreenHeight(BuildContext context) {
  if (_screenHeight != 0) {
    return _screenHeight;
  } else {
    final height = MediaQuery.of(context).size.height;
    _screenHeight = height;

    return _screenHeight;
  }
}

double _statusHeight = 0;

/// 获取系统状态栏高度
double getStatusHeight(BuildContext context) {
  if (_statusHeight != 0) {
    return _statusHeight;
  } else {
    final height = MediaQuery.of(context).padding.top;
    _statusHeight = height;

    return _statusHeight;
  }
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