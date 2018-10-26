import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';

class AppText {
  AppText(this.locale);

  final Locale locale;

  static AppText of(BuildContext context) => Localizations.of(context, AppText);

  static Map<String, Map<String, String>> _localizedValues = {
    "zh": {
      // 通用
      "yes": "是",
      "no": "否",
      "netError": "网络开小差了哦~",

      // 主页
      "weather": "天气",
      "gift": "福利",
      "read": "闲读",
      "setting": "设置",
      "about": "关于",

      // 天气
      "share": "分享",
      "cityControl": "城市管理",
      "dataSource": "数据来源：和风天气",
      "monday": "星期一",
      "tuesday": "星期二",
      "wednesday": "星期三",
      "thursday": "星期四",
      "friday": "星期五",
      "saturday": "星期六",
      "sunday": "星期日",
      "air": "空气",
      "cw": "洗车",
      "uv": "紫外线",
      "trav": "旅游",
      "sport": "运动",
      "drsg": "穿衣",
      "comf": "舒适度",
      "flu": "感冒",
      "pm25": "细颗粒物",
      "so2": "二氧化硫",
      "co": "一氧化碳",
      "pm10": "可吸入颗粒物",
      "no2": "二氧化氮",
      "o3": "臭氧",
      "hum": "湿度",
      "pres": "气压",
      "windSc": "级",

      // 福利

      // 闲读
    },
  };

  /// 通用
  String get yes => _localizedValues[locale.languageCode]["yes"];

  String get no => _localizedValues[locale.languageCode]["no"];

  String get netError => _localizedValues[locale.languageCode]["netError"];

  /// 主页
  String get weather => _localizedValues[locale.languageCode]["weather"];

  String get gift => _localizedValues[locale.languageCode]["gift"];

  String get read => _localizedValues[locale.languageCode]["read"];

  String get setting => _localizedValues[locale.languageCode]["setting"];

  String get about => _localizedValues[locale.languageCode]["about"];

  /// 天气
  String get share => _localizedValues[locale.languageCode]["share"];

  String get cityControl =>
      _localizedValues[locale.languageCode]["cityControl"];

  String get dataSource => _localizedValues[locale.languageCode]["dataSource"];

  String get monday => _localizedValues[locale.languageCode]["monday"];

  String get tuesday => _localizedValues[locale.languageCode]["tuesday"];

  String get wednesday => _localizedValues[locale.languageCode]["wednesday"];

  String get thursday => _localizedValues[locale.languageCode]["thursday"];

  String get friday => _localizedValues[locale.languageCode]["friday"];

  String get saturday => _localizedValues[locale.languageCode]["saturday"];

  String get sunday => _localizedValues[locale.languageCode]["sunday"];

  String get air => _localizedValues[locale.languageCode]["air"];

  String get cw => _localizedValues[locale.languageCode]["cw"];

  String get uv => _localizedValues[locale.languageCode]["uv"];

  String get trav => _localizedValues[locale.languageCode]["trav"];

  String get sport => _localizedValues[locale.languageCode]["sport"];

  String get drsg => _localizedValues[locale.languageCode]["drsg"];

  String get comf => _localizedValues[locale.languageCode]["comf"];

  String get flu => _localizedValues[locale.languageCode]["flu"];

  String get pm25 => _localizedValues[locale.languageCode]["pm25"];

  String get so2 => _localizedValues[locale.languageCode]["so2"];

  String get co => _localizedValues[locale.languageCode]["co"];

  String get pm10 => _localizedValues[locale.languageCode]["pm10"];

  String get no2 => _localizedValues[locale.languageCode]["no2"];

  String get o3 => _localizedValues[locale.languageCode]["o3"];

  String get hum => _localizedValues[locale.languageCode]["hum"];

  String get pres => _localizedValues[locale.languageCode]["pres"];

  String get windSc => _localizedValues[locale.languageCode]["windSc"];

  /// 福利
  /// 闲读
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppText> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ["zh"].contains(locale.languageCode);

  @override
  Future<AppText> load(Locale locale) =>
      SynchronousFuture<AppText>(AppText(locale));

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  static AppLocalizationsDelegate delegate = const AppLocalizationsDelegate();
}
