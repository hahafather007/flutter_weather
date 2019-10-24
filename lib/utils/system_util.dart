import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// 获取运行平台是Android还是IOS
bool get isAndroid => Platform.isAndroid;

bool get isIOS => Platform.isIOS;

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
/// [nowStyle] 当前界面主题（默认黑色，只针对IOS设置）
/// [jumpStyle] 跳转界面的主题（同上）
Future push<T extends StatefulWidget>(BuildContext context,
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

/// 退出应用
void exitApp() => SystemNavigator.pop();

/// 打开浏览器
void openBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "不能打开URL---->$url";
  }
}
