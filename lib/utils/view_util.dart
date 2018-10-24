import 'package:flutter_weather/commom_import.dart';
import 'package:flutter/cupertino.dart';

/// 清除焦点
void cleanFocus(BuildContext context) =>
    FocusScope.of(context).requestFocus(FocusNode());

/// 显示toast
void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIos: 2,
      bgcolor: "#cc333333",
      textcolor: '#ffffff');
}

/// 根据Android或IOS显示不同风格dialog
void showDiffDialog(
    BuildContext context, String title, String content, Function pressed) {
  showDialog(
    context: context,
    builder: (context) => isAndroid
        ? AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                onPressed: () => pop(context),
                child: Text(AppText.of(context).no),
              ),
              FlatButton(
                onPressed: () {
                  pop(context);
                  pressed();
                },
                child: Text(AppText.of(context).yes),
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => pop(context),
                child: Text(AppText.of(context).no),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  pop(context);
                  pressed();
                },
                child: Text(AppText.of(context).yes),
              ),
            ],
          ),
  );
}
