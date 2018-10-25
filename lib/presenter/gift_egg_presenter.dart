import 'package:flutter_weather/commom_import.dart';

class GiftEggPresenter extends Presenter {
  final service = GiftEggService();

  EggData eggData;
  bool isLoading = false;
  int page = 1;

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
    if (isLoading) return;

    try {
      isLoading = true;

      eggData = await service.getData(page: page);
    } on DioError catch (e) {
      doError(e);
    } finally {
      isLoading = false;
    }
  }
}
