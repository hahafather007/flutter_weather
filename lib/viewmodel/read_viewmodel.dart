import 'package:flutter_weather/commom_import.dart';

class ReadViewModel extends ViewModel {
  final _service = ReadService();

  final datas = StreamController<List<ReadData>>();

  List<ReadData> _cacheData = List();
  bool selfLoading = false;
  int _page = 1;
  String _typeUrl;
  LoadType _reloadType = LoadType.NEW_LOAD;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
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
      final list = await _service.getReadDatas(lastUrl: _typeUrl, page: _page);

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
