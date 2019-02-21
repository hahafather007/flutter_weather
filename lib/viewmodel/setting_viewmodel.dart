import 'package:flutter_weather/commom_import.dart';

class SettingViewModel extends ViewModel {
  final cacheSize = StreamController<String>();

  SettingViewModel() {
    isLoading.add(true);

    calculateSize().then((_) => isLoading.add(false));
  }

  void clearCache() async {
    isLoading.add(true);
    final directory = Directory(await DefaultCacheManager().getFilePath());

    if (directory.existsSync()) {
      directory.listSync().forEach((v) => v.deleteSync());

      await calculateSize();
    }

    isLoading.add(false);
  }

  Future<Null> calculateSize() async {
    final directory = Directory(await DefaultCacheManager().getFilePath());

    int size = 0;
    if (directory.existsSync()) {
      directory
          .listSync()
          .map((v) => File(v.path).lengthSync())
          .forEach((length) => size += length);
    }
    cacheSize.add(ByteUtil.calculateSize(size));
  }

  @override
  void dispose() {
    cacheSize.close();

    super.dispose();
  }
}
