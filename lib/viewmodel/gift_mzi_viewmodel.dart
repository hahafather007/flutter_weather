import 'package:flutter_weather/commom_import.dart';

class GiftMziViewModel extends ViewModel {
  final _service = GiftMziService();

  bool isLoading = false;
  int page = 1;

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
    if (isLoading) return;

    isLoading = true;

    try {
      await _service.getData(url: "/mm", page: 1);
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
