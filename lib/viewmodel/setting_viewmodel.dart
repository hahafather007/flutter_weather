import 'dart:async';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/utils/byte_util.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class SettingViewModel extends ViewModel {
  final cacheSize = StreamController<String>();

  SettingViewModel() {
    streamAdd(cacheSize, ByteUtil.calculateSize(0));
  }

  @override
  void dispose() {
    cacheSize.close();

    super.dispose();
  }
}
