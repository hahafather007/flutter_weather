import 'package:flutter_weather/commom_import.dart';

abstract class WeatherBase<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  double _height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullHeight,
      alignment: Alignment.bottomCenter,
      child: buildView(),
    );
  }

  double get fullHeight {
    if (_height == null) {
      _height = getScreenHeight(context) -
          getStatusHeight(context) -
          getAppBarHeight() -
          110;
    }

    return _height;
  }

  @protected
  Widget buildView() {
    return null;
  }
}
