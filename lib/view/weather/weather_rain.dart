import 'package:flutter_weather/commom_import.dart';
import 'weather_base.dart';

/// 雨天、雪天、雾天和冰雹
class WeatherRain extends StatefulWidget {
  final bool rain;
  final bool snow;
  final bool flash;
  final bool fog;
  final bool hail;

  WeatherRain(
      {Key key,
      this.rain = false,
      this.snow = false,
      this.flash = false,
      this.fog = false,
      this.hail = false})
      : super(key: key);

  @override
  State createState() => WeatherRainState();
}

class WeatherRainState extends WeatherBase<WeatherRain> {
  /// 山的移动动画
  AnimationController _mountainController;
  Animation<double> _mountainAnim;

  @override
  void initState() {
    super.initState();

    _mountainController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_mountainAnim == null) {
      final width = getScreenWidth(context);
      _mountainAnim = Tween(begin: -160.0, end: width - 200).animate(
          CurvedAnimation(
              parent: _mountainController,
              curve: const Cubic(0.18, 0.6, 0.4, 1.3)));
    }
  }

  @override
  void dispose() {
    _mountainController?.dispose();

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
              return Positioned(
                child: Image.asset(
                  "images/${widget.snow ? "ic_snow_ground.png" : widget.fog ? "ic_fog_ground.png" : widget.hail ? "ic_hail_ground.png" : "ic_rain_ground.png"}",
                  width: 210,
                ),
                bottom: widget.snow ? -6 : widget.hail ? 0 : -2,
                left: _mountainAnim.value,
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

          // 雾天
          widget.fog
              ? Positioned(
                  child: FogView(),
                  bottom: 0,
                  left: 80,
                )
              : Container(),

          // 冰雹
          widget.hail
              ? Stack(
                  alignment: Alignment.center,
                  children: List.generate(20, (_) => HailView()),
                )
              : Container(),
        ],
      ),
    );
  }
}
