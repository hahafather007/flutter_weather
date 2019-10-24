import 'package:flutter/material.dart';

import 'weather_sunny.dart';
import 'weather_cloud.dart';
import 'weather_rain.dart';
import 'weather_sandstorm.dart';
import 'weather_overcast.dart';

/// 天气显示控件
class WeatherView extends StatefulWidget {
  final String type;
  final Widget child;
  final Color color;
  final bool hide;

  WeatherView(
      {@required this.type,
      @required this.child,
      @required this.color,
      this.hide = false});

  @override
  State createState() => WeatherViewState();
}

class WeatherViewState extends State<WeatherView>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _anim;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _anim = ColorTween(begin: widget.color, end: widget.color)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void didUpdateWidget(WeatherView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != null && oldWidget.color != widget.color) {
      _anim = ColorTween(begin: oldWidget.color, end: widget.color)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget weather;

    if (!widget.hide) {
      final type = widget.type;
      if (type.contains("晴")) {
        weather = AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            return WeatherSunny(
              key: Key("晴"),
              color: _anim.value,
            );
          },
        );
      } else if (type.contains("多云")) {
        weather = AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            return WeatherCloud(
              key: Key("多云"),
              color: _anim.value,
            );
          },
        );
      } else if (type.contains("雷")) {
        weather = WeatherRain(key: Key("雷"), rain: true, flash: true);
      } else if (type.contains("雨")) {
        if (type.contains("雪")) {
          weather = WeatherRain(key: Key("雨夹雪"), rain: true, snow: true);
        } else {
          weather = WeatherRain(key: Key("雨"), rain: true);
        }
      } else if (type.contains("冰雹")) {
        weather = WeatherRain(key: Key("冰雹"), hail: true);
      } else if (type.contains("雪")) {
        weather = WeatherRain(key: Key("雪"), snow: true);
      } else if (type.contains("霾")) {
        weather = WeatherSandstorm(key: Key("霾"), isSmog: true);
      } else if (type.contains("雾")) {
        weather = WeatherRain(key: Key("雾"), fog: true);
      } else if (type.contains("沙")) {
        weather = WeatherSandstorm(key: Key("沙"), isSmog: false);
      } else if (type.contains("阴")) {
        weather = WeatherOvercast(key: Key("阴"));
      } else {
        weather = AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            return WeatherCloud(
              key: Key("多云"),
              color: _anim.value,
            );
          },
        );
      }
    } else {
      weather = Container();
    }

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          child: weather,
          color: widget.color,
        ),
        widget.child,
      ],
    );
  }
}
