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

    bindSub(Observable.zip2(
            Stream.fromFuture(Future.delayed(const Duration(seconds: 1))),
            Stream.fromFuture(SharedDepository().initShared()),
            (a, b) => true)
        .map((_) => SharedDepository().themeColor)
        .doOnData((color) {
      EventSendHolder().sendEvent(tag: "themeChange", event: color);
      push(context, page: HomePage(), replace: true);
    }).listen(null));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Image.asset(
          "images/splash.png",
          fit: isAndroid ? BoxFit.fill : BoxFit.fitHeight,
          width: getScreenWidth(context),
          height: getScreenHeight(context),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
