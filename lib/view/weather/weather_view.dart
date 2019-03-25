import 'package:flutter_weather/commom_import.dart';
import 'weather_sunny.dart';
import 'weather_cloud.dart';
import 'weather_rain.dart';

class WeatherView extends StatefulWidget {
  final String type;
  final Widget child;
  final Color color;

  WeatherView(
      {@required this.type, @required this.child, @required this.color});

  @override
  State createState() => WeatherViewState();
}

class WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    Widget weather;

    final type = widget.type;
    if (type.contains("晴")) {
      weather = WeatherSunny(key: Key("晴"));
    } else if (type.contains("多云")) {
      weather = WeatherCloud(key: Key("多云"));
    } else if (type.contains("雨")) {
      if (type.contains("雪")) {
        weather = WeatherRain(key: Key("雨夹雪"), rain: true, snow: true);
      } else {
        weather = WeatherRain(key: Key("雨"), rain: true, snow: false);
      }
    } else if (type.contains("雪")) {
      weather = WeatherRain(key: Key("雪"), rain: false, snow: true);
    } else {
      weather = WeatherCloud(key: Key("多云"));
    }

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(seconds: 3),
          child: weather,
          color: widget.color,
        ),
        widget.child,
      ],
    );
  }
}
