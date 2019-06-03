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
      "cancel": "取消",
      "certain": "确定",
      "unknown": "未知",
      "wait": "稍后",
      "install": "安装",
      "download": "下载",
      "appName": "假装看天气(Flutter)",

      // 主页
      "weather": "天气",
      "gift": "福利",
      "read": "闲读",
      "collect": "收藏",
      "setting": "设置",
      "about": "关于",
      "retryToExit": "再按一次退出App！",

      // 天气
      "cityControl": "城市管理",
      "cityChoose": "城市选择",
      "repeatCity": "重复的城市！",
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
      "weathersView": "动态天气预览",
      "sunny": "晴",
      "cloudy": "多云",
      "overcast": "阴",
      "rain": "雨",
      "flashRain": "雷雨",
      "snowRain": "雨夹雪",
      "snow": "雪",
      "hail": "冰雹",
      "fog": "雾",
      "smog": "雾霾",
      "sandstorm": "沙尘暴",

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
      "imgSave": "保存图片",
      "imgSaveSuccess": "图片保存成功！",
      "imgSaveFail": "图片保存失败！",

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

      // 收藏
      "giftPhotos": "福利(图集)",
      "listEmpty": "列表为空",

      // 设置
      "moduleControl": "模块管理",
      "caculating": "正在计算...",
      "shareType": "分享形式",
      "likeHammer": "仿锤子便签",
      "commonUse": "通用",
      "themeColor": "主题色",
      "chooseTheme": "选择主题色",
      "openOrCloseModule": "启用/关闭模块",
      "clearCache": "清除缓存",
      "colorLapisBlue": "青石色",
      "colorPaleDogWood": "山茱萸",
      "colorGreenery": "绿篱",
      "colorPrimroseYellow": "樱草黄",
      "colorFlame": "烈焰红",
      "colorIslandParadise": "天堂岛",
      "colorKale": "甘蓝",
      "colorPinkYarrow": "粉蓍草",
      "colorNiagara": "尼亚加拉",
      "colorNone": "丢雷老母",

      // 关于
      "hasNewVersion": "检测到新版本",
      "hasNewVersionLong": "已有新版本等待下载，是否立即下载更新？（继续使用旧版本可能会发生意想不到的错误）",
      "hasNewVersionLongIOS": "IOS请自行拉去代码编译！（继续使用旧版本可能会发生意想不到的错误）",
      "newVersionReady": "新版本准备就绪",
      "newVersionReadyLong": "新版本的安装包已经在WIFI环境下载完成，是否立即安装？（该过程不消耗流量）",
      "apkSize": "APK大小：",
      "apkPleaseInstall": "APK下载成功！请安装",
      "apkFail": "APK下载失败！",
      "apkDownloading": "应用正在更新中！",
      "apkStartDownload": "安装包开始下载",
      "checkUpdateFail": "检测更新失败，请检查网络！",
      "overview": "概述",
      "programHome": "项目主页",
      "feedback": "意见反馈",
      "checkUpdate": "检查更新",
      "alreadyNew": "已是最新版本！",
      "shareApp": "分享应用",
      "shareAppUrl":
          "来不及了，赶急上车！https://github.com/hahafather007/flutter_weather",
      "thanks": "感谢",
      "connectMe": "联系我",
      "zhihuPage": "活雷轰-知乎",
      "zhihuName": "• @活雷轰",
      "thankItems":
          "• 和风天气提供天气数据\n• 高德定位提供定位服务\n• 『Gank』『煎蛋』『妹子图』提供妹纸数据\n• 丰富精彩的开源世界 https://github.com/hahafather007/flutter_weather/blob/master/README.md",
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

  String get cancel => _localizedValues[locale.languageCode]["cancel"];

  String get certain => _localizedValues[locale.languageCode]["certain"];

  String get unknown => _localizedValues[locale.languageCode]["unknown"];

  String get appName => _localizedValues[locale.languageCode]["appName"];

  String get wait => _localizedValues[locale.languageCode]["wait"];

  String get install => _localizedValues[locale.languageCode]["install"];

  String get download => _localizedValues[locale.languageCode]["download"];

  String get alreadyCopyUrl =>
      _localizedValues[locale.languageCode]["alreadyCopyUrl"];

  String get openByOther =>
      _localizedValues[locale.languageCode]["openByOther"];

  /// 主页
  String get weather => _localizedValues[locale.languageCode]["weather"];

  String get gift => _localizedValues[locale.languageCode]["gift"];

  String get read => _localizedValues[locale.languageCode]["read"];

  String get setting => _localizedValues[locale.languageCode]["setting"];

  String get collect => _localizedValues[locale.languageCode]["collect"];

  String get about => _localizedValues[locale.languageCode]["about"];

  String get retryToExit =>
      _localizedValues[locale.languageCode]["retryToExit"];

  /// 天气
  String get share => _localizedValues[locale.languageCode]["share"];

  String get cityChoose => _localizedValues[locale.languageCode]["cityChoose"];

  String get repeatCity => _localizedValues[locale.languageCode]["repeatCity"];

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

  String get sunny => _localizedValues[locale.languageCode]["sunny"];

  String get cloudy => _localizedValues[locale.languageCode]["cloudy"];

  String get overcast => _localizedValues[locale.languageCode]["overcast"];

  String get rain => _localizedValues[locale.languageCode]["rain"];

  String get flashRain => _localizedValues[locale.languageCode]["flashRain"];

  String get snowRain => _localizedValues[locale.languageCode]["snowRain"];

  String get snow => _localizedValues[locale.languageCode]["snow"];

  String get hail => _localizedValues[locale.languageCode]["hail"];

  String get fog => _localizedValues[locale.languageCode]["fog"];

  String get smog => _localizedValues[locale.languageCode]["smog"];

  String get sandstorm => _localizedValues[locale.languageCode]["sandstorm"];

  String get weathersView =>
      _localizedValues[locale.languageCode]["weathersView"];

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

  String get imgSaveSuccess =>
      _localizedValues[locale.languageCode]["imgSaveSuccess"];

  String get imgSaveFail =>
      _localizedValues[locale.languageCode]["imgSaveFail"];

  String get imgSave => _localizedValues[locale.languageCode]["imgSave"];

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

  /// 收藏
  String get giftPhotos => _localizedValues[locale.languageCode]["giftPhotos"];

  String get listEmpty => _localizedValues[locale.languageCode]["listEmpty"];

  /// 设置
  String get moduleControl =>
      _localizedValues[locale.languageCode]["moduleControl"];

  String get caculating => _localizedValues[locale.languageCode]["caculating"];

  String get shareType => _localizedValues[locale.languageCode]["shareType"];

  String get likeHammer => _localizedValues[locale.languageCode]["likeHammer"];

  String get commonUse => _localizedValues[locale.languageCode]["commonUse"];

  String get themeColor => _localizedValues[locale.languageCode]["themeColor"];

  String get chooseTheme =>
      _localizedValues[locale.languageCode]["chooseTheme"];

  String get openOrCloseModule =>
      _localizedValues[locale.languageCode]["openOrCloseModule"];

  String get clearCache => _localizedValues[locale.languageCode]["clearCache"];

  String get colorLapisBlue =>
      _localizedValues[locale.languageCode]["colorLapisBlue"];

  String get colorPaleDogWood =>
      _localizedValues[locale.languageCode]["colorPaleDogWood"];

  String get colorGreenery =>
      _localizedValues[locale.languageCode]["colorGreenery"];

  String get colorPrimroseYellow =>
      _localizedValues[locale.languageCode]["colorPrimroseYellow"];

  String get colorFlame => _localizedValues[locale.languageCode]["colorFlame"];

  String get colorIslandParadise =>
      _localizedValues[locale.languageCode]["colorIslandParadise"];

  String get colorKale => _localizedValues[locale.languageCode]["colorKale"];

  String get colorPinkYarrow =>
      _localizedValues[locale.languageCode]["colorPinkYarrow"];

  String get colorNiagara =>
      _localizedValues[locale.languageCode]["colorNiagara"];

  String get colorNone => _localizedValues[locale.languageCode]["colorNone"];

  /// 关于
  String get overview => _localizedValues[locale.languageCode]["overview"];

  String get programHome =>
      _localizedValues[locale.languageCode]["programHome"];

  String get feedback => _localizedValues[locale.languageCode]["feedback"];

  String get checkUpdate =>
      _localizedValues[locale.languageCode]["checkUpdate"];

  String get alreadyNew => _localizedValues[locale.languageCode]["alreadyNew"];

  String get shareApp => _localizedValues[locale.languageCode]["shareApp"];

  String get thanks => _localizedValues[locale.languageCode]["thanks"];

  String get connectMe => _localizedValues[locale.languageCode]["connectMe"];

  String get zhihuPage => _localizedValues[locale.languageCode]["zhihuPage"];

  String get zhihuName => _localizedValues[locale.languageCode]["zhihuName"];

  String get thankItems => _localizedValues[locale.languageCode]["thankItems"];

  String get shareAppUrl =>
      _localizedValues[locale.languageCode]["shareAppUrl"];

  String get hasNewVersion =>
      _localizedValues[locale.languageCode]["hasNewVersion"];

  String get hasNewVersionLong =>
      _localizedValues[locale.languageCode]["hasNewVersionLong"];

  String get hasNewVersionLongIOS =>
      _localizedValues[locale.languageCode]["hasNewVersionLongIOS"];

  String get newVersionReady =>
      _localizedValues[locale.languageCode]["newVersionReady"];

  String get newVersionReadyLong =>
      _localizedValues[locale.languageCode]["newVersionReadyLong"];

  String get apkSize => _localizedValues[locale.languageCode]["apkSize"];

  String get apkPleaseInstall =>
      _localizedValues[locale.languageCode]["apkPleaseInstall"];

  String get apkFail => _localizedValues[locale.languageCode]["apkFail"];

  String get apkDownloading =>
      _localizedValues[locale.languageCode]["apkDownloading"];

  String get apkStartDownload =>
      _localizedValues[locale.languageCode]["apkStartDownload"];

  String get checkUpdateFail =>
      _localizedValues[locale.languageCode]["checkUpdateFail"];
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
