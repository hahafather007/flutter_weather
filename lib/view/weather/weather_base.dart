import 'package:flutter_weather/commom_import.dart';

abstract class WeatherBase<T extends StatefulWidget> extends State {
  final Widget child;
  final Color backColor;

  WeatherBase({@required this.child, @required this.backColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          color: backColor,
          height: getScreenHeight(context) -
              getSysStatsHeight(context) -
              AppBar().preferredSize.height -
              110,
          alignment: Alignment.bottomCenter,
          child: buildView(),
        ),

        // 显示在背景前面的内容
        child,
      ],
    );
  }

  @protected
  Widget buildView() {
    return null;
  }
}
