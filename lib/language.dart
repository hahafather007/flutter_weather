import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

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
      "refresh": "刷新",
      "addFav": "收藏",
      "share": "分享",
      "openByOther": "其他方式打开",
      "copyUrl": "复制URL",
      "alreadyCopyUrl": "已复制链接",
      "retry": "重试",
      "loadFail": "加载失败！",

      // 主页
      "weather": "天气",
      "gift": "福利",
      "read": "闲读",
      "setting": "设置",
      "about": "关于",

      // 天气
      "cityControl": "城市管理",
      "dataSource": "数据来源：和风天气",
      "monday": "星期一",
      "tuesday": "星期二",
      "wednesday": "星期三",
      "thursday": "星期四",
      "friday": "星期五",
      "saturday": "星期六",
      "sunday": "星期日",
      "today": "今天",
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
      "weatherFail": "天气信息获取失败！",

      // 福利
      "gank": "Gank",
      "egg": "煎蛋",
      "mostHot": "最热",
      "sexGirl": "性感妹子",
      "japanGirl": "日本妹子",
      "taiwanGirl": "台湾妹子",
      "beachGirl": "清纯妹子",
      "selfGirl": "妹子自拍",
      "allGirl": "每日更新",
      "landGirl": "街拍美女",
      "imageSet": "图集",
      "gankFail": "Gank获取失败！",
      "eggFail": "煎蛋获取失败！",
      "mostHotFail": "最热获取失败！",
      "sexGirlFail": "性感妹子获取失败！",
      "japanGirlFail": "日本妹子获取失败！",
      "taiwanGirFail": "台湾妹子获取失败！",
      "beachGirlFail": "清纯妹子获取失败！",
      "selfGirlFail": "妹子自拍获取失败！",
      "allGirlFail": "每日更新获取失败！",
      "landGirlFail": "街拍美女获取失败！",
      "imageSetFail": "组图加载是失败！",

      // 闲读
      "xiandu": "科技资讯",
      "xianduApps": "趣味软件/游戏",
      "xianduImrich": "装备党",
      "xianduFunny": "草根新闻",
      "xianduAndroid": "Android",
      "xianduDie": "创业新闻",
      "xianduThink": "独立思想",
      "xianduIos": "iOS",
      "xianduBlog": "团队博客",
      "xianduFail": "科技资讯获取失败！",
      "xianduAppsFail": "趣味软件/游戏获取失败！",
      "xianduImrichFail": "装备党获取失败！",
      "xianduFunnyFail": "草根新闻获取失败！",
      "xianduAndroidFail": "Android获取失败！",
      "xianduDieFail": "创业新闻获取失败！",
      "xianduThinkFail": "独立思想获取失败！",
      "xianduIosFail": "iOS获取失败！",
      "xianduBlogFail": "团队博客获取失败！",
    },
  };

  /// 通用
  String get yes => _localizedValues[locale.languageCode]["yes"];

  String get no => _localizedValues[locale.languageCode]["no"];

  String get netError => _localizedValues[locale.languageCode]["netError"];

  String get refresh => _localizedValues[locale.languageCode]["refresh"];

  String get addFav => _localizedValues[locale.languageCode]["addFav"];

  String get retry => _localizedValues[locale.languageCode]["retry"];

  String get copyUrl => _localizedValues[locale.languageCode]["copyUrl"];

  String get loadFail => _localizedValues[locale.languageCode]["loadFail"];

  String get alreadyCopyUrl =>
      _localizedValues[locale.languageCode]["alreadyCopyUrl"];

  String get openByOther =>
      _localizedValues[locale.languageCode]["openByOther"];

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

  String get today => _localizedValues[locale.languageCode]["today"];

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

  String get weatherFail =>
      _localizedValues[locale.languageCode]["weatherFail"];

  /// 福利
  String get gank => _localizedValues[locale.languageCode]["gank"];

  String get egg => _localizedValues[locale.languageCode]["egg"];

  String get mostHot => _localizedValues[locale.languageCode]["mostHot"];

  String get sexGirl => _localizedValues[locale.languageCode]["sexGirl"];

  String get japanGirl => _localizedValues[locale.languageCode]["japanGirl"];

  String get taiwanGirl => _localizedValues[locale.languageCode]["taiwanGirl"];

  String get beachGirl => _localizedValues[locale.languageCode]["beachGirl"];

  String get selfGirl => _localizedValues[locale.languageCode]["selfGirl"];

  String get landGirl => _localizedValues[locale.languageCode]["landGirl"];

  String get allGirl => _localizedValues[locale.languageCode]["allGirl"];

  String get imageSet => _localizedValues[locale.languageCode]["imageSet"];

  String get gankFail => _localizedValues[locale.languageCode]["gankFail"];

  String get eggFail => _localizedValues[locale.languageCode]["eggFail"];

  String get mostHotFail =>
      _localizedValues[locale.languageCode]["mostHotFail"];

  String get sexGirlFail =>
      _localizedValues[locale.languageCode]["sexGirlFail"];

  String get japanGirlFail =>
      _localizedValues[locale.languageCode]["japanGirlFail"];

  String get taiwanGirFail =>
      _localizedValues[locale.languageCode]["taiwanGirFail"];

  String get beachGirlFail =>
      _localizedValues[locale.languageCode]["beachGirlFail"];

  String get selfGirlFail =>
      _localizedValues[locale.languageCode]["selfGirlFail"];

  String get allGirlFail =>
      _localizedValues[locale.languageCode]["allGirlFail"];

  String get landGirlFail =>
      _localizedValues[locale.languageCode]["landGirlFail"];

  String get imageSetFail =>
      _localizedValues[locale.languageCode]["imageSetFail"];

  /// 闲读
  String get xiandu => _localizedValues[locale.languageCode]["xiandu"];

  String get xianduApps => _localizedValues[locale.languageCode]["xianduApps"];

  String get xianduImrich =>
      _localizedValues[locale.languageCode]["xianduImrich"];

  String get xianduFunny =>
      _localizedValues[locale.languageCode]["xianduFunny"];

  String get xianduAndroid =>
      _localizedValues[locale.languageCode]["xianduAndroid"];

  String get xianduDie => _localizedValues[locale.languageCode]["xianduDie"];

  String get xianduThink =>
      _localizedValues[locale.languageCode]["xianduThink"];

  String get xianduIos => _localizedValues[locale.languageCode]["xianduIos"];

  String get xianduBlog => _localizedValues[locale.languageCode]["xianduBlog"];

  String get xianduFail => _localizedValues[locale.languageCode]["xianduFail"];

  String get xianduAppsFail =>
      _localizedValues[locale.languageCode]["xianduAppsFail"];

  String get xianduImrichFail =>
      _localizedValues[locale.languageCode]["xianduImrichFail"];

  String get xianduFunnyFail =>
      _localizedValues[locale.languageCode]["xianduFunnyFail"];

  String get xianduAndroidFail =>
      _localizedValues[locale.languageCode]["xianduAndroidFail"];

  String get xianduDieFail =>
      _localizedValues[locale.languageCode]["xianduDieFail"];

  String get xianduThinkFail =>
      _localizedValues[locale.languageCode]["xianduThinkFail"];

  String get xianduIosFail =>
      _localizedValues[locale.languageCode]["xianduIosFail"];

  String get xianduBlogFail =>
      _localizedValues[locale.languageCode]["xianduBlogFail"];
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
