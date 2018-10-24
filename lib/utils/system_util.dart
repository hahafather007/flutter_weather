import 'package:flutter_weather/commom_import.dart';

/// 获取运行平台是Android还是IOS
bool get isAndroid => Platform.isAndroid;

bool get isIOS => Platform.isIOS;

/// 获取当前版本信息
String get versionName => "0.0.1";

/// 获取屏幕宽度
double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

/// 获取屏幕高度
double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

/// 获取系统状态栏高度
double getSysStatsHeight(BuildContext context) =>
    MediaQuery.of(context).padding.top;

/// 关闭窗口
void pop(BuildContext context, {int count = 1, dynamic extraData}) {
  if (count == 1) {
    Navigator.pop(context, extraData);

    return;
  }

  for (int i = 0; i < count; i++) {
    Navigator.pop(context);
  }
}

/// 开启一个窗口
/// [replace] 是否代替当前界面
/// [nowStyle] 当前界面主题（默认黑色，只针对IOS设置）
/// [jumpStyle] 跳转界面的主题（同上）
Future push<T extends StatefulWidget>(BuildContext context,
    {@required T page,
    bool replace = false,
    SystemUiOverlayStyle nowStyle = SystemUiOverlayStyle.dark,
    SystemUiOverlayStyle jumpStyle = SystemUiOverlayStyle.dark}) {
  final route = MaterialPageRoute(builder: (_) => page);

  Future future;

  if (isIOS) {
    SystemChrome.setSystemUIOverlayStyle(jumpStyle);
  }

  if (replace) {
    future = Navigator.of(context).pushReplacement(route);
  } else {
    future = Navigator.of(context).push(route);
  }

  return future.then((v) {
    if (isIOS) {
      SystemChrome.setSystemUIOverlayStyle(nowStyle);
    }

    return v;
  });
}

/// 退出应用
void exitApp() => SystemNavigator.pop();

/// 打开浏览器
void openBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "不能打开URL---->$url";
  }
}
