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

  /// 小船的动画
  AnimationController _boatController;
  Animation<double> _boatAnimation;

  /// 白云的动画
  AnimationController _cloudController;
  Animation<double> _cloudAnimation;

  WeatherSunnyState({@required this.child})
      : super(child: child, backColor: Colors.lightBlueAccent);

  @override
  void initState() {
    super.initState();

    _boatController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..forward();
    _boatAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _boatController, curve: Curves.ease));

    _cloudController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..forward();
    _boatAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _boatController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _boatController?.dispose();
    _cloudController?.dispose();

    super.dispose();
  }

  @override
  Widget buildView() {
    return AnimatedBuilder(
      animation: _boatAnimation,
      builder: (context, child) {
        return WaveView(
          amplitude: 15,
          amplitudePercent: _boatAnimation.value,
          color: Colors.white,
          waveNum: 2,
          height: 120,
          imgRight: 100 * _boatAnimation.value,
          imgUrl: "images/ic_boat_day.png",
          imgSize: const Size(60, 18),
        );
      },
    );
  }
}
