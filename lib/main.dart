import 'commom_import.dart';
import 'package:flutter/rendering.dart';

void main() {
  // 显示布局边框
  debugPaintSizeEnabled = false;

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      home: SplashPage(),
      theme: ThemeData(accentColor: AppColor.colorMain),

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
