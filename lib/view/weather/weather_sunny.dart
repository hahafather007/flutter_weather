import 'package:flutter_weather/commom_import.dart';
import 'weather_base.dart';

class WeatherSunny extends StatefulWidget {
  final Widget child;

  WeatherSunny({Key key, @required this.child}) : super(key: key);

  @override
  State createState() => WeatherSunnyState(child: child);
}

class WeatherSunnyState extends WeatherBase<WeatherSunny> {
  final Widget child;

  WeatherSunnyState({@required this.child})
      : super(child: child, backColor: Colors.lightBlueAccent);

  @override
  Widget buildView() {
    return WaveView(
      amplitude: 15,
      color: Colors.white,
      waveNum: 2,
      height: 100,
    );
  }
}
