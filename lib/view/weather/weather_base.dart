import 'package:flutter_weather/commom_import.dart';

abstract class WeatherBase<T extends StatefulWidget> extends State {
  Color get backColor => Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor,
      height: getScreenHeight(context) -
          getSysStatsHeight(context) -
          AppBar().preferredSize.height -
          110,
      child: buildView(),
    );
  }

  Widget buildView() {
    return Container();
  }
}
