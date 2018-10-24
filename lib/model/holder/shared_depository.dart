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
  String get lastCity => _getString("lastCity", defaultValue: "成都");

  Future<bool> setLastCity(String value) async =>
      await _prefs.setString("lastCity", value);

  /// 用带有默认值的形式获取prefs的数据
  String _getString(String key, {String defaultValue}) {
    final value = _prefs.getString(key);

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
