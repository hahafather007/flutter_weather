import 'package:flutter/material.dart';

/// 圆形的太阳
class SunView extends StatelessWidget {
  /// 外围轮廓颜色
  final Color outColor;

  SunView({@required this.outColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.white,
            Colors.white,
            outColor,
          ]),
          shape: BoxShape.circle),
      child: Container(
        height: 32,
        width: 32,
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
