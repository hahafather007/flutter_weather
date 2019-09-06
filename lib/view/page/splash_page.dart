import 'package:flutter_weather/commom_import.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends PageState<SplashPage> {
  @override
  void initState() {
    super.initState();

    bindSub(
        Observable.zip2(
                Stream.fromFuture(
                    Future.delayed(const Duration(milliseconds: 500))),
                Stream.fromFuture(SharedDepository().initShared()),
                (a, b) => b)
            .map((shared) => shared.themeColor)
            .map((color) =>
                EventSendHolder().sendEvent(tag: "themeChange", event: color))
            .listen((_) => push(context, page: HomePage(), replace: true)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Image.asset(
          "images/splash.png",
          fit: isAndroid ? BoxFit.fill : BoxFit.fitHeight,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
