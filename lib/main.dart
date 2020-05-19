import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_weather/view/page/splash_page.dart';
import 'package:rxdart/rxdart.dart';

//> Could not resolve io.flutter:flutter_embedding_release:1.0.0-540786dd51f112885a89792d678296b95e6622e5.
//> Could not get resource 'https://storage.googleapis.com/download.flutter.io/io/flutter/flutter_embedding_release/1.0.0-540786dd51f112885a89792d678296b95e6622e5/flutter_embedding_release-1.0.0-540786dd51f112885a89792d678296b95e6622e5.pom'.
//> Could not GET 'https://storage.googleapis.com/download.flutter.io/io/flutter/flutter_embedding_release/1.0.0-540786dd51f112885a89792d678296b95e6622e5/flutter_embedding_release-1.0.0-540786dd51f112885a89792d678296b95e6622e5.pom'.
//> Read timed out

void main() {
  Stream.value(WidgetsFlutterBinding.ensureInitialized())
      // 显示布局边框
      .doOnData((_) => debugPaintSizeEnabled = false)
      // 设置状态栏字体颜色
      .doOnData((_) => SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.black,
              systemNavigationBarDividerColor: null,
              statusBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark)))
      // 强制竖屏
      .asyncMap((_) => SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]))
      .asyncMap((_) => SharedDepository().initShared())
      .listen((_) => runApp(WeatherApp()));
}

class WeatherApp extends StatefulWidget {
  /// 切换语言
  static ValueChanged<Locale> localChange;

  /// app语言信息
  static Locale locale;

  @override
  State createState() => WeatherAppState();
}

class WeatherAppState extends State<WeatherApp> with StreamSubController {
  ThemeData theme = ThemeData();
  Locale _locale;

  @override
  void initState() {
    super.initState();

    WeatherApp.localChange = (locale) {
      setState(() => _locale = Locale(locale.languageCode, ""));
      WeatherApp.locale = _locale;
    };

    EventSendHolder()
        .event
        .where((pair) => pair.a == "themeChange")
        .listen(
            (pair) => setState(() => theme = ThemeData(accentColor: pair.b)))
        .bindLife(this);
  }

  @override
  void dispose() {
    subDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      title: "假装看天气-Flutter版",
      locale: _locale,
      theme: theme,

      // 设置地区信息
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      // 国际化多语言支持
      supportedLocales: S.delegate.supportedLocales,

      // 设置语言
      localeListResolutionCallback: (locales, supports) {
        Locale result = SharedDepository().appLocale;
        if (result == null) {
          result = const Locale("en", "");

          final supportCodes = supports.map((v) => v.languageCode).toList();
          for (Locale locale in locales) {
            if (supportCodes.contains(locale.languageCode)) {
              result = Locale(locale.languageCode, "");
              break;
            }
          }
        }

        WeatherApp.locale = result;

        return result;
      },
    );
  }
}
