import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/widget/toast_view.dart';

/// 清除焦点
void cleanFocus(BuildContext context) =>
    FocusScope.of(context).requestFocus(FocusNode());

/// 根据Android或IOS显示不同风格dialog
Future<void> showDiffDialog(BuildContext context,
    {Widget title,
    Widget content,
    String yesText,
    String noText,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    Function pressed}) async {
  await showDialog(
    context: context,
    builder: (context) => isAndroid
        ? AlertDialog(
            title: title,
            content: content,
            contentPadding: contentPadding,
            actions: <Widget>[
              noText != null
                  ? FlatButton(
                      onPressed: () => pop(context),
                      child: Text(noText),
                    )
                  : Container(),
              yesText != null
                  ? FlatButton(
                      onPressed: () => pressed(),
                      child: Text(yesText),
                    )
                  : Container(),
            ],
          )
        : CupertinoAlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              noText != null
                  ? CupertinoDialogAction(
                      onPressed: () => pop(context),
                      child: Text(noText),
                    )
                  : Container(),
              yesText != null
                  ? CupertinoDialogAction(
                      onPressed: () => pressed(),
                      child: Text(yesText),
                    )
                  : Container(),
            ],
          ),
  );
}

class ToastUtil {
  static OverlayEntry _overlayEntry;

  /// 显示toast
  static Future<void> showToast(BuildContext context, String msg) async {
    if (msg == null) return;

    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
        builder: (context) => LayoutBuilder(
            builder: (context, constraints) => ToastView(msg: msg)));
    Overlay.of(context).insert(_overlayEntry);
  }
}
