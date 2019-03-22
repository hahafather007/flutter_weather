import 'package:flutter_weather/commom_import.dart';
import 'weather_base.dart';

class WeatherSunny extends StatefulWidget {
  WeatherSunny({
    Key key,
  }) : super(key: key);

  @override
  State createState() => WeatherSunnyState();
}

class WeatherSunnyState extends WeatherBase<WeatherSunny> {
  /// 小船动画
  AnimationController _boatController;
  Animation<double> _boatAnimation;

  /// 太阳动画
  Animation<double> _sunAnimation;

  WeatherSunnyState()
      : super(
            backColor: DateTime.now().hour >= 6 && DateTime.now().hour < 18
                ? Color(0xFF51C0F8)
                : Color(0xFF7F9EE9));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _boatController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..forward();
    _boatAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _boatController, curve: Curves.ease));
    // 太阳动画结束位置根据时间变更
    // 6~18点为白天，18~第二天6点为夜晚
    int now = DateTime.now().hour;
    if (now < 6) {
      now += 24;
      now -= 18;
    } else if (now >= 18) {
      now -= 18;
    } else {
      now -= 6;
    }
    final sunEnd = (getScreenWidth(context) - 78) * now / 12 + 39;
    _sunAnimation = Tween(begin: 39.0, end: sunEnd)
        .animate(CurvedAnimation(parent: _boatController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _boatController?.dispose();

    super.dispose();
  }

  @override
  Widget buildView() {
    final width = getScreenWidth(context);
    // 是否为白天
    final isDay = DateTime.now().hour >= 6 && DateTime.now().hour < 18;

    return Container(
      height: fullHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // 太阳
          AnimatedBuilder(
            animation: _sunAnimation,
            builder: (context, child) {
              return Positioned(
                child: Container(
                  width: 42,
                  height: 42,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      // 圆形的太阳
                      Container(
                        height: 38,
                        width: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: RadialGradient(colors: [
                              Colors.white,
                              Colors.white,
                              backColor,
                            ]),
                            shape: BoxShape.circle),
                        child: Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      ),

                      // 遮罩太阳一部分让其看起来像月亮
                      isDay
                          ? Container()
                          : Container(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: backColor),
                              ),
                            ),
                    ],
                  ),
                ),
                left: _sunAnimation.value - 19,
                bottom: sin(pi * _sunAnimation.value / width) * 265,
              );
            },
          ),

          // 波浪
          AnimatedBuilder(
            animation: _boatAnimation,
            builder: (context, child) {
              return WaveView(
                amplitude: 15,
                amplitudePercent: _boatAnimation.value,
                color: isDay ? Colors.white : Color(0xE63A66CF),
                waveNum: 2,
                height: 120,
                imgRight: 100 * _boatAnimation.value,
                imgUrl: "images/ic_boat_${isDay ? "day" : "night"}.png",
                imgSize: const Size(60, 18),
              );
            },
          ),
        ],
      ),
    );
  }
}
