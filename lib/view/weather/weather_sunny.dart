import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/widget/wave_view.dart';

import 'weather_base.dart';

/// 晴天
class WeatherSunny extends StatefulWidget {
  final Color color;

  WeatherSunny({Key key, @required this.color}) : super(key: key);

  @override
  State createState() => WeatherSunnyState();
}

class WeatherSunnyState extends WeatherBase<WeatherSunny> {
  /// 小船动画
  AnimationController _boatController;
  Animation<double> _boatAnim;

  /// 太阳动画
  Animation<double> _sunAnim;

  @override
  void initState() {
    super.initState();

    _boatController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..forward();
    _boatAnim = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _boatController, curve: Curves.ease));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_sunAnim == null) {
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
      _sunAnim = Tween(begin: 39.0, end: sunEnd).animate(
          CurvedAnimation(parent: _boatController, curve: Curves.ease));
    }
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
            animation: _sunAnim,
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
                              widget.color,
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
                                    shape: BoxShape.circle,
                                    color: widget.color),
                              ),
                            ),
                    ],
                  ),
                ),
                left: _sunAnim.value - 19,
                bottom: sin(pi * _sunAnim.value / width) * 265,
              );
            },
          ),

          // 波浪
          AnimatedBuilder(
            animation: _boatAnim,
            builder: (context, child) {
              return WaveView(
                amplitude: 15,
                amplitudePercent: _boatAnim.value,
                color: isDay ? Colors.white : Color(0xE63A66CF),
                waveNum: 2,
                height: 120,
                imgRight: 100 * _boatAnim.value,
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
