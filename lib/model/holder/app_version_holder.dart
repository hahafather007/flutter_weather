import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/service/app_version_service.dart';
import 'package:flutter_weather/utils/channel_util.dart';
import 'package:flutter_weather/utils/log_util.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/utils/view_util.dart';
import 'package:package_info/package_info.dart';

class AppVersionHolder {
  /// 使用单利模式管理
  static final AppVersionHolder _holder = AppVersionHolder._internal();

  factory AppVersionHolder() => _holder;

  final _service = AppVersionService();

  AppVersionHolder._internal();

  Future<void> checkUpdate(BuildContext context) async {
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
                  title: Text(S.of(context).newVersionReady),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(S.of(context).newVersionReadyLong),
                      Container(height: 12),
                      Text(
                        "${S.of(context).updateTime}${version.time}",
                        style: TextStyle(fontSize: 14, color: AppColor.text2),
                      ),
                      Text(
                        "${S.of(context).apkSize}${version.size}",
                        style: TextStyle(fontSize: 14, color: AppColor.text2),
                      ),
                    ],
                  ),
                  yesText: S.of(context).install,
                  noText: S.of(context).wait,
                  onPressed: () =>
                      ChannelUtil.installApp(verCode: version.version));
            }
          } else {
            await showDiffDialog(
              context,
              title: Text(S.of(context).hasNewVersion),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).hasNewVersionLong),
                  Container(height: 12),
                  Text(
                    "${S.of(context).updateTime}${version.time}",
                    style: TextStyle(fontSize: 14, color: AppColor.text2),
                  ),
                  Text(
                    "${S.of(context).apkSize}${version.size}",
                    style: TextStyle(fontSize: 14, color: AppColor.text2),
                  ),
                ],
              ),
              yesText: S.of(context).download,
              noText: S.of(context).wait,
              onPressed: () async {
                pop(context);

                ToastUtil.showToast(context, S.of(context).apkStartDownload);
                final readyUpdate = await ChannelUtil.updateApp(
                    url: version.url, verCode: version.version, isWifi: false);

                if (readyUpdate) {
                  ToastUtil.showToast(context, S.of(context).apkPleaseInstall);
                } else {
                  ToastUtil.showToast(context, S.of(context).apkFail);
                }
              },
            );
          }
        } else {
          await showDiffDialog(context,
              title: Text(S.of(context).hasNewVersion),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).hasNewVersionLongIOS),
                  Container(height: 12),
                  Text(
                    "${S.of(context).updateTime}${version.time}",
                    style: TextStyle(fontSize: 14, color: AppColor.text2),
                  ),
                ],
              ),
              yesText: S.of(context).certain,
              noText: S.of(context).wait,
              onPressed: () => pop(context));
        }
      }
    } on DioError catch (e) {
      debugLog(e.toString());
    }
  }

  void dispose() {
    _service.dispose();
  }
}
