import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/city_data.dart';
import 'package:flutter_weather/model/data/page_module_data.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';

/// SharedPreference的管理仓库
class SharedDepository {
  /// 使用单利模式管理
  static final SharedDepository _depository = SharedDepository._internal();

  final _prefs = window.localStorage;

  factory SharedDepository() => _depository;

  SharedDepository._internal() {
    debugPrint("SharedDepository初始化完成！");
  }

  /// 获取所有城市定位
  List<District> get districts {
    final json = _prefs["districts"];
    if (json == null) {
      return [District(name: "成都", id: "CN101270101")];
    }
    return (jsonDecode(json) as List)
        .map((v) => jsonDecode(v))
        .map((v) => District.fromJson(v))
        .toList();
  }

  void setDistricts(List<District> value) => _prefs["districts"] =
      jsonEncode(value.map((v) => jsonEncode(v)).toList());

  /// 所有城市天气情况
  List<Weather> get weathers {
    final json = _prefs["weathersData"];
    if (json == null) {
      return [Weather()];
    } else {
      return (jsonDecode(json) as List)
          .map((v) => jsonDecode(v))
          .map((v) => Weather.fromJson(v))
          .toList();
    }
  }

  void setWeathers(List<Weather> value) => _prefs["weathersData"] =
      jsonEncode(value.map((v) => jsonEncode(v)).toList());

  /// 所有城市空气质量
  List<WeatherAir> get airs {
    final json = _prefs["airsData"];
    if (json == null) {
      return [WeatherAir()];
    } else {
      return (jsonDecode(json) as List)
          .map((v) => jsonDecode(v))
          .map((v) => WeatherAir.fromJson(v))
          .toList();
    }
  }

  void setAirs(List<WeatherAir> value) =>
      _prefs["airsData"] = jsonEncode(value.map((v) => jsonEncode(v)).toList());

  /// 收藏的闲读文章
  String get favReadData => _prefs["favReadData"];

  void setFavReadData(String value) => _prefs["favReadData"] = value;

  /// 收藏的妹子图
  String get favMziData => _prefs["favMziData"];

  void setFavMziData(String value) => _prefs["favMziData"] = value;

  /// 当前主题色
  Color get themeColor {
    final json = _prefs["themeColor"];
    if (json == null) {
      return const Color(0xff7da743);
    }

    return Color(int.parse(_prefs["themeColor"]));
  }

  void setThemeColor(Color color) =>
      _prefs["themeColor"] = color.value.toString();

  /// 页面模块
  List<PageModule> get pageModules {
    final json = _prefs["pageModules2"];
    if (json == null) {
      return [
        PageModule(module: "weather", open: true),
        PageModule(module: "gift", open: true),
        PageModule(module: "read", open: true),
        PageModule(module: "collect", open: true),
      ];
    } else {
      return (jsonDecode(json) as List)
          .map((v) => PageModule.fromJson(v))
          .toList();
    }
  }

  void setPageModules(List<PageModule> modules) => _prefs["pageModules2"] =
      jsonEncode(modules.map((v) => jsonEncode(v)).toList());
}
