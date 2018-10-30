import 'package:flutter_weather/commom_import.dart';

class GiftEggViewModel extends ViewModel {
  final _service = GiftEggService();

  EggData eggData;
  int page = 1;

  void init() {
    loadData();
  }

  Future<Null> loadData({bool isRefresh = true}) async {
//    if (await isLoading.stream.last) return;
//    isLoading.add(true);

    try {
      eggData = await _service.getData(page: page);
    } on DioError catch (e) {
      doError(e);
    } finally {
//      isLoading.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _service.dispose();
  }
}
