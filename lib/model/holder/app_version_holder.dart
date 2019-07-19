import 'package:flutter_weather/commom_import.dart';
import 'package:dio/dio.dart';

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

          if (isWifi) {
            final readyUpdate = await ChannelUtil.updateApp(
                url: version.url, verCode: version.version, isWifi: true);

            if (readyUpdate) {
              await showDiffDialog(context,
                  title: Text(AppText.of(context).newVersionReady),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppText.of(context).newVersionReadyLong),
                      Container(height: 12),
                      Text(
                        "${AppText.of(context).updateTime}${version.time}",
                        style:
                            TextStyle(fontSize: 14, color: AppColor.colorText2),
                      ),
                      Text(
                        "${AppText.of(context).apkSize}${version.size}",
                        style:
                            TextStyle(fontSize: 14, color: AppColor.colorText2),
                      ),
                    ],
                  ),
                  yesText: AppText.of(context).install,
                  noText: AppText.of(context).wait,
                  pressed: () =>
                      ChannelUtil.installApp(verCode: version.version));
            }
          } else {
            await showDiffDialog(
              context,
              title: Text(AppText.of(context).hasNewVersion),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppText.of(context).hasNewVersionLong),
                  Container(height: 12),
                  Text(
                    "${AppText.of(context).updateTime}${version.time}",
                    style: TextStyle(fontSize: 14, color: AppColor.colorText2),
                  ),
                  Text(
                    "${AppText.of(context).apkSize}${version.size}",
                    style: TextStyle(fontSize: 14, color: AppColor.colorText2),
                  ),
                ],
              ),
              yesText: AppText.of(context).download,
              noText: AppText.of(context).wait,
              pressed: () async {
                pop(context);

                ToastUtil.showToast(AppText.of(context).apkStartDownload);
                final readyUpdate = await ChannelUtil.updateApp(
                    url: version.url, verCode: version.version, isWifi: false);

                if (readyUpdate) {
                  ToastUtil.showToast(AppText.of(context).apkPleaseInstall);
                } else {
                  ToastUtil.showToast(AppText.of(context).apkFail);
                }
              },
            );
          }
        } else {
          await showDiffDialog(context,
              title: Text(AppText.of(context).hasNewVersion),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppText.of(context).hasNewVersionLongIOS),
                  Container(height: 12),
                  Text(
                    "${AppText.of(context).updateTime}${version.time}",
                    style: TextStyle(fontSize: 14, color: AppColor.colorText2),
                  ),
                ],
              ),
              yesText: AppText.of(context).certain,
              noText: AppText.of(context).wait,
              pressed: () => pop(context));
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
