import 'package:flutter_weather/commom_import.dart';

abstract class WeatherBase<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  final Color backColor;

  double _height;

  WeatherBase({@required this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor,
      height: fullHeight,
      alignment: Alignment.bottomCenter,
      child: buildView(),
    );
  }

  double get fullHeight {
    if (_height == null) {
      _height = getScreenHeight(context) -
          getSysStatsHeight(context) -
          AppBar().preferredSize.height -
          110;
    }

    return _height;
  }

  @protected
  Widget buildView() {
    return null;
  }
}
