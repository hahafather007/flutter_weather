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

  WeatherSunnyState({@required this.child});

  @override
  Widget buildView() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        WaveView(
          amplitude: 15,
          color: Colors.white,
          waveNum: 2,
          height: 100,
        ),
        child,
      ],
    );
  }
}
