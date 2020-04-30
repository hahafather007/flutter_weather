import 'dart:async';
import 'dart:io';

import 'package:flutter_weather/utils/byte_util.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class SettingViewModel extends ViewModel {
  final cacheSize = StreamController<String>();

  SettingViewModel() {
    isLoading.safeAdd(true);

    calculateSize().then((_) => isLoading.safeAdd(false));
  }

  Future<void> clearCache()  async {
    isLoading.safeAdd(true);
    final cacheDir = Directory(await DefaultCacheManager().getFilePath());
    final documentDir =
        Directory((await getApplicationDocumentsDirectory()).path);

    if (cacheDir.existsSync()) {
      cacheDir.listSync().forEach((v) => v.deleteSync());
    }
    if (documentDir.existsSync()) {
      documentDir
          .listSync()
          .where((v) => v.path.contains(".png"))
          .forEach((v) => v.deleteSync());
    }

    await calculateSize();

    isLoading.safeAdd(false);
  }

  Future<void> calculateSize() async {
    final cacheDir = Directory(await DefaultCacheManager().getFilePath());
    final documentDir =
        Directory((await getApplicationDocumentsDirectory()).path);

    int size = 0;
    if (cacheDir.existsSync()) {
      cacheDir
          .listSync()
          .map((v) => File(v.path).lengthSync())
          .forEach((length) => size += length);
    }
    if (documentDir.existsSync()) {
      documentDir
          .listSync()
          .where((v) => v.path.contains(".png"))
          .map((v) => File(v.path).lengthSync())
          .forEach((length) => size += length);
    }

    cacheSize.safeAdd(ByteUtil.calculateSize(size));
  }

  @override
  void dispose() {
    cacheSize.close();

    super.dispose();
  }
}
