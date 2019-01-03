import 'package:flutter/rendering.dart';

import 'commom_import.dart';

void main() {
  // 显示布局边框
  debugPaintSizeEnabled = false;

  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      theme: ThemeData(
          accentColor: AppColor.colorMain, platform: TargetPlatform.android),

      // 设置地区信息
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalizationsDelegate.delegate,
      ],

      // 国际化多语言支持
      supportedLocales: [
        const Locale("zh", "CH"),
      ],
    );
  }
}
