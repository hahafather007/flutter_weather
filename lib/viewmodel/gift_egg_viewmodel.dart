import 'package:flutter_weather/commom_import.dart';

class GiftEggViewModel extends ViewModel {
  final _service = GiftEggService();
  final _loadingController = StreamController<bool>();

  Stream<bool> get isLoading =>_loadingController.stream;

  EggData eggData;
  int page = 1;

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
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
    _loadingController.close();
  }
}
