import 'package:flutter_weather/commom_import.dart';

class WeatherView extends StatefulWidget {
  final String type;
  final Widget child;

  WeatherView({@required this.type, @required this.child});

  @override
  State createState() => WeatherViewState();
}

class WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    Widget weather;

    switch (widget.type) {
      case "多云":
        weather = WeatherCloud();
        break;
      default:
        weather = WeatherSunny();
        break;
    }

    return Stack(
      children: <Widget>[
        weather,
        widget.child,
      ],
    );
  }
}
