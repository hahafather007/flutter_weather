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
    switch (widget.type) {
      case "多云":
        return WeatherCloud(
          key: Key("WeatherCloud${DateTime.now().millisecondsSinceEpoch}"),
          child: widget.child,
        );
      default:
        return WeatherSunny(
          key: Key("WeatherSunny${DateTime.now().millisecondsSinceEpoch}"),
          child: widget.child,
        );
    }
  }
}
