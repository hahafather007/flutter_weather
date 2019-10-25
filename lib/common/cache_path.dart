import 'package:flutter_weather/utils/system_util.dart' show isIOS;

/// 网络图片的缓存目录
abstract class CachePath {
  static const _ANDROID_PATH =
      "/data/user/0/com.hahafather007.flutterweather/cachecache/";
  static const _IOS_PATH =
      "Directory: '/Users/father/Library/Developer/CoreSimulator/Devices/9D38FFB3-DBDB-4C84-9139-9E11E4C92909/data/Containers/Data/Application/C6E99308-9B58-45DD-845B-55A659CEB1DC/Documents'";

  static String CACHE_PATH = isIOS ? _IOS_PATH : _ANDROID_PATH;
}
