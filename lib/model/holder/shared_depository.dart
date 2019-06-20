import 'package:flutter_weather/commom_import.dart';

/// SharedPreference的管理仓库
class SharedDepository {
  /// 使用单利模式管理
  static final SharedDepository _depository = SharedDepository._internal();

  SharedPreferences _prefs;

  factory SharedDepository() => _depository;

  SharedDepository._internal() {
    debugPrint("SharedDepository初始化完成！");
  }

  Future<SharedDepository> initShared() async {
    _prefs = await SharedPreferences.getInstance();

    debugPrint("prefs======$_prefs");

    return this;
  }

  /// 获取所有城市定位
  List<String> get cities => _getStringList("cities", defaultValue: ["成都"]);

  Future<bool> setCities(List<String> value) async =>
      await _prefs.setStringList("cities", value);

  /// 所有城市天气情况
  List<Weather> get weathers {
    final list = _getStringList("weathersData");
    if (list == null || list.isEmpty) {
      return [Weather()];
    } else {
      return list
          .map((v) => jsonDecode(v))
          .map((v) => Weather.fromJson(v))
          .toList();
    }
  }

  Future<bool> setWeathers(List<Weather> value) async => await _prefs
      .setStringList("weathersData", value.map((v) => jsonEncode(v)).toList());

  /// 所有城市空气质量
  List<WeatherAir> get airs {
    final list = _getStringList("airsData");
    if (list == null || list.isEmpty) {
      return [WeatherAir()];
    } else {
      return list
          .map((v) => jsonDecode(v))
          .map((v) => WeatherAir.fromJson(v))
          .toList();
    }
  }

  Future<bool> setAirs(List<WeatherAir> value) async => await _prefs
      .setStringList("airsData", value.map((v) => jsonEncode(v)).toList());

  /// 收藏的闲读文章
  String get favReadData => _getString("favReadData");

  Future<bool> setFavReadData(String value) async =>
      await _prefs.setString("favReadData", value);

  /// 收藏的妹子图
  String get favMziData => _getString("favMziData");

  Future<bool> setFavMziData(String value) async =>
      await _prefs.setString("favMziData", value);

  /// 当前主题色
  Color get themeColor =>
      Color(_getInt("themeColor", defaultValue: 0xff7DA743));

  Future<bool> setThemeColor(Color color) async =>
      await _prefs.setInt("themeColor", color.value);

  /// 图片本地缓存目录
  String get imgCachePath => _getString("imgCachePath");

  Future<bool> setImgCachePath(String path) async =>
      await _prefs.setString("imgCachePath", path);

  /// 页面模块
  List<PageModule> get pageModules {
    final str = _getString("pageModules2");
    if (str == null) {
      return List.from([
        PageModule(module: "weather", open: true),
        PageModule(module: "gift", open: true),
        PageModule(module: "read", open: true),
        PageModule(module: "collect", open: true),
      ]);
    } else {
      return (jsonDecode(str) as List)
          .map((v) => PageModule.fromJson(v))
          .toList();
    }
  }

  Future<bool> setPageModules(List<PageModule> modules) async =>
      await _prefs.setString("pageModules2", jsonEncode(modules));

  /// 天气分享形式是否为锤子分享
  bool get hammerShare => _getBool("hammerShare", defaultValue: true);

  Future<bool> setHammerShare(bool value) async =>
      await _prefs.setBool("hammerShare", value);

  /// ==============================================
  ///                     分界线
  /// ==============================================
  /// 用带有默认值的形式获取prefs的数据
  String _getString(String key, {String defaultValue}) {
    final value = _prefs.getString(key);

    if (value == null) {
      return defaultValue;
    }

    return value;
  }

  List<String> _getStringList(String key, {List<String> defaultValue}) {
    final list = _prefs.getStringList(key);

    if (list == null) {
      return defaultValue;
    }

    return list;
  }

  int _getInt(String key, {int defaultValue}) {
    final value = _prefs.getInt(key);

    if (value == null) {
      return defaultValue;
    }

    return value;
  }

  bool _getBool(String key, {bool defaultValue = false}) {
    final value = _prefs.getBool(key);

    if (value == null) {
      return defaultValue;
    }

    return value;
  }
}
