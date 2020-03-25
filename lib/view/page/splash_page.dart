import 'package:flutter/material.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/home_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends PageState<SplashPage> {
  @override
  void initState() {
    super.initState();

    Observable.timer(Null, const Duration(milliseconds: 500))
        .map((shared) => SharedDepository().themeColor)
        .map((color) =>
            EventSendHolder().sendEvent(tag: "themeChange", event: color))
        .listen((_) => push(context, page: HomePage(), replace: true))
        .bindLife(this);
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
