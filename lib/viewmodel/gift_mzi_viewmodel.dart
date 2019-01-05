import 'package:flutter_weather/commom_import.dart';

class GiftMziViewModel extends ViewModel {
  final _service = GiftMziService();

  final datas = StreamController<List<MziData>>();

  List<MziData> _cacheData = List();
  bool selfLoading = false;
  int _page = 1;
  LoadType _reloadType = LoadType.NEW_LOAD;

  void init() {
    loadData(type: LoadType.NEW_LOAD);
  }

  Future<Null> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type == LoadType.NEW_LOAD) {
      isLoading.add(true);
    } else if (type == LoadType.REFRESH) {
      _page = 1;
      _cacheData.clear();
    }
    try {
      final list = await _service.getData(url: "/mm", page: _page);
      _cacheData.addAll(list);
      datas.add(_cacheData.toList());
      _page++;
    } on DioError catch (e) {
      _reloadType = type;
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.add(false);
    }
  }

  void reload() {
    loadData(type: _reloadType);
  }

  void loadMore() {
    loadData(type: LoadType.LOAD_MORE);
  }

  @override
  void dispose() {
    _service.dispose();
    _cacheData.clear();

    datas.close();

    super.dispose();
  }
}
