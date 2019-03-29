import 'package:flutter_weather/commom_import.dart';
import 'weather_base.dart';

/// 雨天和雪天
class WeatherRain extends StatefulWidget {
  final bool rain;
  final bool snow;
  final bool flash;

  WeatherRain(
      {Key key, @required this.rain, @required this.snow, @required this.flash})
      : super(key: key);

  @override
  State createState() => WeatherRainState();
}

class WeatherRainState extends WeatherBase<WeatherRain> {
  /// 山的移动动画
  AnimationController _mountainController;
  AnimationController _mountainController2;
  Animation<double> _mountainAnim;
  Animation<double> _mountainAnim2;

  @override
  void initState() {
    super.initState();

    _mountainController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward()
          ..addStatusListener((statue) {
            // 往右移动完毕之后开始回弹
            if (statue == AnimationStatus.completed) {
              _mountainController2.forward();
            }
          });
    _mountainController2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_mountainAnim == null || _mountainAnim2 == null) {
      final width = getScreenWidth(context);
      _mountainAnim = Tween(begin: -160.0, end: width - 160).animate(
          CurvedAnimation(parent: _mountainController, curve: Curves.easeOut));
      _mountainAnim2 = Tween(begin: width - 160, end: width - 200).animate(
          CurvedAnimation(parent: _mountainController2, curve: Curves.ease));
    }
  }

  @override
  void dispose() {
    _mountainController?.dispose();
    _mountainController2?.dispose();

    super.dispose();
  }

  @override
  Widget buildView() {
    return Container(
      height: fullHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // 山
          AnimatedBuilder(
            animation: _mountainAnim,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: _mountainAnim2,
                builder: (context, child) {
                  final left =
                      _mountainController.status == AnimationStatus.completed
                          ? _mountainAnim2.value
                          : _mountainAnim.value;

                  return Positioned(
                    child: Image.asset(
                      "images/${!widget.rain && widget.snow ? "ic_snow_ground.png" : "ic_rain_ground.png"}",
                      width: 210,
                      height: 90,
                    ),
                    bottom: -10,
                    left: left,
                  );
                },
              );
            },
          ),

          // 雨天
          widget.rain && !widget.snow
              ? Stack(
                  alignment: Alignment.center,
                  children: List.generate(40, (_) => RainView()),
                )
              : Container(),

          // 雨夹雪
          widget.rain && widget.snow
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children:
                          List.generate(10, (_) => RainView(bigWind: false)),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: List.generate(10, (_) => SnowView()),
                    ),
                  ],
                )
              : Container(),

          // 雪天
          !widget.rain && widget.snow
              ? Stack(
                  alignment: Alignment.center,
                  children:
                      List.generate(40, (_) => SnowView(fullScreen: true)),
                )
              : Container(),

          // 闪电
          widget.flash
              ? Positioned(
                  child: FlashView(
                    height: 200,
                    width: 200,
                  ),
                  bottom: 80,
                  right: 80,
                )
              : Container(),
        ],
      ),
    );
  }
}
