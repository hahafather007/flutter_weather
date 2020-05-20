import 'package:flutter/material.dart';
import 'package:flutter_weather/utils/system_util.dart';

void debugLog(dynamic msg) {
  if (!isDebug) return;

  debugPrint("$msg");
}
