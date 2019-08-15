import 'package:flutter_weather/commom_import.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    SharedDepository().initShared().then((_) {
      EventSendHolder()
          .sendEvent(tag: "themeChange", event: SharedDepository().themeColor);
      push(context, page: HomePage(), replace: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Image.asset(
          "images/splash.png",
          fit: isAndroid ? BoxFit.fill : BoxFit.fitHeight,
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
