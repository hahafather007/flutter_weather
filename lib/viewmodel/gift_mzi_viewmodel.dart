import 'package:flutter_weather/commom_import.dart';

class GiftMziViewModel extends ViewModel {
  final _service = GiftMziService();

  final datas = StreamController<List<MziData>>();

  List<MziData> _totalDatas = List();
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
      final data = await _service.getData(url: "/mm", page: _page);
      _totalDatas.addAll(data);

      datas.add(_totalDatas);
    } on DioError catch (e) {
      doError(e);
    } finally {
      _loading = false;

      if (!isRefresh) {
        isLoading.add(false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _service.dispose();
    _totalDatas.clear();

    datas.close();
  }
}
