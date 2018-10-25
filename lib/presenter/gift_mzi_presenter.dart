import 'package:flutter_weather/commom_import.dart';

class GiftMziPresenter extends Presenter {
  final service = GiftMziService();

  GiftMziInter inter;
  bool isLoading = false;
  int page = 1;

  GiftMziPresenter(this.inter);

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
    if (isLoading) return;

    try {
      isLoading = true;

      await service.getData(url: "/mm", page: 1);
    } on DioError catch (e) {
      doError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();

    inter = null;
  }
}
