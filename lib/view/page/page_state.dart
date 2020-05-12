import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:path_provider/path_provider.dart';

export 'package:flutter_weather/common/streams.dart'
    show SubscriptionExt, ControllerExt;

abstract class PageState<T extends StatefulWidget> extends State<T>
    with StreamSubController, WidgetsBindingObserver {
  @protected
  final scafKey = GlobalKey<ScaffoldState>();
  @protected
  final boundaryKey = GlobalKey();

  bool get bindLife => false;

  @override
  void initState() {
    super.initState();

    if (bindLife) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  /// 获取屏幕截图
  @protected
  Future<File> takeScreenshot() async {
    final boundary =
        boundaryKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);
    final directory = (await getApplicationDocumentsDirectory()).path;
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    final file = await File(
            "$directory/weather_${DateTime.now().millisecondsSinceEpoch}.png")
        .writeAsBytes(pngBytes);

    return file;
  }

  /// 网络错误弹窗
  void networkError({@required String errorText, @required VoidCallback retry}) {
    scafKey.currentState.removeCurrentSnackBar();
    scafKey.currentState.showSnackBar(SnackBar(
      content: Text(errorText),
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: S.of(context).retry,
        onPressed: retry,
      ),
    ));
  }

  void showSnack(
      {@required String text,
      Duration duration = const Duration(milliseconds: 2000),
      SnackBarAction action}) {
    scafKey.currentState.removeCurrentSnackBar();
    scafKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: duration,
      action: action,
    ));
  }

  @protected
  void onResume() {}

  @protected
  void onPause() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      onResume();
    } else if (state == AppLifecycleState.paused) {
      onPause();
    }
  }

  @override
  void dispose() {
    subDispose();
    if (bindLife) {
      WidgetsBinding.instance.removeObserver(this);
    }

    super.dispose();
  }
}
