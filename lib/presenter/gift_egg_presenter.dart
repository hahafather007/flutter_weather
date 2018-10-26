import 'package:flutter_weather/commom_import.dart';

class GiftEggPresenter extends Presenter {
  final _service = GiftEggService();

  EggData eggData;
  bool isLoading = false;
  int page = 1;

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
    if (isLoading) return;

    isLoading = true;

    try {

      eggData = await _service.getData(page: page);
    } on DioError catch (e) {
      doError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _service.dispose();
  }
}
