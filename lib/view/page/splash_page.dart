import 'package:flutter_weather/commom_import.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<SplashPage> with StreamSubController {
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
  void dispose() {
    subDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Image.asset(
          "images/splash.png",
          fit: isAndroid ? BoxFit.fill : BoxFit.fitHeight,
          height: getScreenHeight(context),
          width: getScreenWidth(context),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
