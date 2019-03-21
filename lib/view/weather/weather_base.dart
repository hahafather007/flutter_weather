import 'package:flutter_weather/commom_import.dart';

abstract class WeatherBase<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  final Widget child;
  final Color backColor;

  double _height;

  WeatherBase({@required this.child, @required this.backColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          color: backColor,
          height: fullHeight,
          alignment: Alignment.bottomCenter,
          child: buildView(),
        ),

        // 显示在背景前面的内容
        child,
      ],
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
