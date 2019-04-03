import 'package:flutter_weather/commom_import.dart';
import 'weather_base.dart';

/// 沙尘暴和雾霾
class WeatherSandstorm extends StatefulWidget {
  /// 是否为雾霾天
  final bool isSmog;

  WeatherSandstorm({Key key, @required this.isSmog}) : super(key: key);

  @override
  State createState() => WeatherSandstormState();
}

class WeatherSandstormState extends WeatherBase<WeatherSandstorm> {
  /// 进入动画
  AnimationController _controller;
  Animation<double> _anim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..forward();
    _anim = Tween(begin: -pi / 2, end: 0.0).animate(CurvedAnimation(
        parent: _controller, curve: const Cubic(0.4, 0.8, 0.75, 1.6)));
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  @override
  Widget buildView() {
    return Container(
      height: fullHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          /// 波浪作为雾霾和沙尘暴背景
          WaveView(
            amplitude: 15,
            amplitudePercent: 1,
            color: widget.isSmog
                ? const Color(0xFFB6B7C2)
                : const Color(0xFFF2C790),
            waveNum: 2,
            height: 140,
            imgRight: 100,
          ),

          Positioned(
            right: 50,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                // 参考https://medium.com/flutter-io/perspective-on-flutter-6f832f4d912e
                return Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateX(_anim.value),
                  child: Image.asset(
                    "images/ic_${widget.isSmog ? "haze" : "sanstorm"}_ground.png",
                    width: 150,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
