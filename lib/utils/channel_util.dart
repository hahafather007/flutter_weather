import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/model/data/city_data.dart';
import 'package:flutter_weather/utils/system_util.dart';

import 'log_util.dart';

class ChannelUtil {
  /// 平台通道工具
  static final _platform = MethodChannel(_ChannelTag.CHANNEL_NAME);

  /// 获取位置
  static Future<City> getLocation() async {
    City city;

    try {
      final String result =
          await _platform.invokeMethod(_ChannelTag.START_LOCATION);
      if (result?.isNotEmpty == true) {
        final str = result
            .replaceFirst("区", "")
            .replaceFirst("县", "")
            .replaceFirst("市", "")
            .replaceFirst("省", "");
        city = City.fromJson(jsonDecode(str));
      }
    } on PlatformException catch (e) {
      _doError(e);
    } on MissingPluginException catch (e) {
      _doError(e);
    }

    return city;
  }

  /// 调用系统邮件
  static Future<bool> sendEmail({@required String email}) async {
    bool result = false;
    try {
      result = await _platform.invokeMethod(_ChannelTag.SEND_EMAIL, {
        "email": email,
      });
    } on PlatformException catch (e) {
      _doError(e);
    }

    return result;
  }

  /// 更新安装包
  static Future<bool> updateApp(
      {@required String url,
      @required int verCode,
      @required bool isWifi}) async {
    bool result = false;
    try {
      result = await _platform.invokeMethod(_ChannelTag.DOWNLOAD_APK, {
        "url": url,
        "verCode": verCode,
        "isWifi": isWifi,
      });
    } on PlatformException catch (e) {
      _doError(e);
    }

    return result;
  }

  /// 更新安装包
  static Future<Null> installApp({@required int verCode}) async {
    try {
      await _platform.invokeMethod(_ChannelTag.INSTALL_APK, {
        "verCode": verCode,
      });
    } on PlatformException catch (e) {
      _doError(e);
    }
  }

  /// 判断是否正在下载安装包
  static Future<bool> isDownloading() async {
    bool result = false;
    if (isAndroid) {
      try {
        result = await _platform.invokeMethod(_ChannelTag.IS_DOWNLOADING);
      } on PlatformException catch (e) {
        _doError(e);
      }
    }

    return result;
  }

  /// 设置壁纸
  static Future<Null> setWallpaper({@required String path}) async {
    try {
      await _platform.invokeMethod(_ChannelTag.SET_WALLPAPER, {
        "path": path,
      });
    } on PlatformException catch (e) {
      _doError(e);
    }
  }

  static void _doError<T extends Exception>(T e) =>
      debugLog("=====>通道错误：${e.toString()}");
}

/// 平台通道的名字和方法
abstract class _ChannelTag {
  static const CHANNEL_NAME = "flutter_weather_channel";
  static const START_LOCATION = "weatherStartLocation";
  static const SEND_EMAIL = "weatherSendEmail";
  static const DOWNLOAD_APK = "weatherDownloadApk";
  static const INSTALL_APK = "weatherInstallApk";
  static const IS_DOWNLOADING = "weatherIsDownloading";
  static const SET_WALLPAPER = "weatherSetWallpaper";
}
