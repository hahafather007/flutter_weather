import 'package:flutter/material.dart';
import 'package:flutter_weather/utils/system_util.dart';

extension LogExt on dynamic {
  void logStr() {
    if (isDebug) return;

    debugPrint("$this");
  }
}
