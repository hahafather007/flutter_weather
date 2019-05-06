import 'package:flutter_weather/commom_import.dart';

class AppVersionHolder {
  /// 使用单利模式管理
  static final AppVersionHolder _holder = AppVersionHolder._internal();

  factory AppVersionHolder() => _holder;

  final _service = AppVersionService();

  AppVersionHolder._internal();

  void checkUpdate(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final packageInfo = await PackageInfo.fromPlatform();
    try {
      final version = await _service.getVersion();
      final needUpdate = int.parse(packageInfo.buildNumber) < version.version;

      if (needUpdate) {
        if (isAndroid) {
          final isWifi = await Connectivity().checkConnectivity() ==
              ConnectivityResult.wifi;
          final readyUpdate = await ChannelUtil.updateApp(
              url: version.url, verCode: version.version, isWifi: isWifi);

          if (readyUpdate) {
            showDiffDialog(context,
                title: Text("新版本准备就绪"),
                content: Text("新版本的安装包已经在WIFI环境下载完成，是否立即安装？（该过程不消耗流量）"),
                yesText: "安装",
                noText: "稍后",
                pressed: () =>
                    ChannelUtil.installApp(verCode: version.version));
          }
        }
      }
    } on DioError catch (e) {
      debugPrint(e.toString());
    }
  }

  void dispose() {
    _service.dispose();
  }
}
