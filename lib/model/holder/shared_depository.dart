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

  /// 上一次城市定位
  String get lastCity => _getString("lastCity", defaultValue: "成都,成都");

  Future<bool> setLastCity(String value) async =>
      await _prefs.setString("lastCity", value);

  /// 上次获取天气数据的时间
  String get weatherUpdateTime => _getString("weatherUpdateTime",
      defaultValue: DateTime.now().subtract(Duration(days: 1)).toString());

  Future<bool> setWeatherUpdateTime(String value) async =>
      await _prefs.setString("weatherUpdateTime", value);

  /// 上次天气情况数据
  String get lastWeatherData => _getString("lastWeatherData");

  Future<bool> setLastWeatherData(String value) async =>
      await _prefs.setString("lastWeatherData", value);

  /// 上次空气质量情况
  String get lastAirData => _getString("lastAirData");

  Future<bool> setLastAirData(String value) async =>
      await _prefs.setString("lastAirData", value);

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
