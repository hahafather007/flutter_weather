import 'package:flutter_weather/commom_import.dart';
import 'package:flutter/cupertino.dart';

/// 清除焦点
void cleanFocus(BuildContext context) =>
    FocusScope.of(context).requestFocus(FocusNode());

/// 根据Android或IOS显示不同风格dialog
Future<Null> showDiffDialog(BuildContext context,
    {Widget title,
    Widget content,
    String yesText,
    String noText,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
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
  static OverlayState _overlayState;
  static BuildContext _toastContext;

  /// 显示toast
  static void showToast(String msg) async {
    if (msg == null) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    _overlayState = Overlay.of(_toastContext);
    _overlayEntry = OverlayEntry(
        builder: (context) => LayoutBuilder(
            builder: (context, constraints) => ToastView(msg: msg)));

    _overlayState?.insert(_overlayEntry);
  }

  static void initToast(BuildContext context) {
    _toastContext = context;
  }

  static void disposeToast() {
    _toastContext = null;
  }
}

class ToastView extends StatefulWidget {
  final String msg;

  ToastView({@required this.msg});

  @override
  State createState() => ToastState(msg: msg);
}

class ToastState extends State<ToastView> with TickerProviderStateMixin {
  final String msg;

  AnimationController _controller;
  Animation<double> _animation;
  Timer _timer;

  ToastState({@required this.msg});

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: const Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 2300), () {
      _controller?.dispose();
      setState(() {
        _controller = AnimationController(
            animationBehavior: AnimationBehavior.preserve,
            vsync: this,
            duration: const Duration(milliseconds: 200));
        _animation = Tween(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 36, right: 36),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: _animation.value != 0
                ? Material(
                    color: const Color(0xDD444444),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                      child: Text(
                        msg,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
          );
        },
      ),
    );
  }
}
