import 'package:flutter/material.dart';

class AqiUtil {
  /// 根据空气指数获得颜色
  static Color getAqiColor(double aqi) {
    Color color;
    if (aqi <= 50) {
      color = Color(0xFF6BCD07);
    } else if (aqi <= 100) {
      color = Color(0xFFFBD029);
    } else if (aqi <= 150) {
      color = Color(0xFFFE8800);
    } else if (aqi <= 200) {
      color = Color(0xFFFE0000);
    } else if (aqi <= 300) {
      color = Color(0xFF970454);
    } else {
      color = Color(0xFF62001E);
    }

    return color;
  }
}
