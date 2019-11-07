import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/streams.dart';
import 'language.dart';
import 'model/holder/event_send_holder.dart';
import 'view/page/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() => MyAppState();
}

class MyAppState extends State<MyApp> with StreamSubController {
  ThemeData _theme = ThemeData();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    subDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(
        onThemeChange: (color) {
          setState(() {
            _theme = ThemeData(accentColor: color);
          });
        },
      ),
      theme: _theme,

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
