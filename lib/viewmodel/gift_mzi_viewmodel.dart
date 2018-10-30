import 'package:flutter_weather/commom_import.dart';

class GiftMziViewModel extends ViewModel {
  final _service = GiftMziService();

  final datas = StreamController<List<MziData>>();

  bool _loading = false;
  int _page = 1;

  void init() {
    loadData();
  }

  Future<Null> loadData({bool isRefresh = true}) async {
    if (_loading) return;
    _loading = true;

    if (!isRefresh) {
      isLoading.add(true);
    }

    try {
      await _service.getData(url: "/mm", page: _page);
    } on DioError catch (e) {
      doError(e);
    } finally {
      _loading = true;

      if (!isRefresh) {
        isLoading.add(false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _service.dispose();

    datas.close();
  }
}
