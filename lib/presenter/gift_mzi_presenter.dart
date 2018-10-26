import 'package:flutter_weather/commom_import.dart';

class GiftMziPresenter extends Presenter {
  final _service = GiftMziService();

  GiftMziInter _inter;

  bool isLoading = false;
  int page = 1;

  GiftMziPresenter(this._inter);

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
    if (isLoading) return;

    isLoading = true;
    _inter.stateChange();

    try {
      await _service.getData(url: "/mm", page: 1);
    } on DioError catch (e) {
      doError(e);
    } finally {
      isLoading = false;
      _inter.stateChange();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _inter = null;
    _service.dispose();
  }
}
