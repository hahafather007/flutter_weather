import 'package:flutter_weather/commom_import.dart';

class SettingViewModel extends ViewModel {
  final cacheSize = StreamController<String>();

  SettingViewModel() {
    streamAdd(isLoading, true);

    calculateSize().then((_) => streamAdd(isLoading, false));
  }

  void clearCache() async {
    streamAdd(isLoading, true);
    final directory = Directory(await DefaultCacheManager().getFilePath());

    if (directory.existsSync()) {
      directory.listSync().forEach((v) => v.deleteSync());

      await calculateSize();
    }

    streamAdd(isLoading, false);
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
    streamAdd(cacheSize, ByteUtil.calculateSize(size));
  }

  @override
  void dispose() {
    cacheSize.close();

    super.dispose();
  }
}
