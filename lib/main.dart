import 'package:flutter/rendering.dart';

import 'commom_import.dart';

void main() {
  // 显示布局边框
  debugPaintSizeEnabled = false;

  // 设置状态栏字体颜色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark));

  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State createState() => MyAppState();
}

class MyAppState extends PageState<MyApp> {
  ThemeData theme = ThemeData();

  @override
  void initState() {
    super.initState();

    bindSub(EventSendHolder()
        .event
        .where((pair) => pair.a == "themeChange")
        .listen(
            (pair) => setState(() => theme = ThemeData(accentColor: pair.b))));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      theme: theme,

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
