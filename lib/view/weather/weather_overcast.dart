import 'package:flutter_weather/commom_import.dart';
import 'weather_base.dart';

class WeatherOvercast extends StatefulWidget {
  WeatherOvercast({Key key}) : super(key: key);

  @override
  State createState() => WeatherOvercastState();
}

class WeatherOvercastState extends WeatherBase<WeatherOvercast> {
  @override
  Widget buildView() {
    return Container(
      height: fullHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          MountainView(),
        ],
      ),
    );
  }
}
