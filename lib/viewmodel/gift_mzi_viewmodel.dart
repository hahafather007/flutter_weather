import 'package:flutter_weather/commom_import.dart';

class GiftMziViewModel extends ViewModel {
  final _service = GiftMziService();

  final data = StreamController<List<MziData>>();
  final _photoData = StreamController<List<MziData>>();

  Stream<List<MziData>> photoStream;

  List<MziData> _cacheData = List();
  int _page = 1;
  String _typeUrl;
  LoadType _reloadType = LoadType.NEW_LOAD;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
    photoStream = _photoData.stream.asBroadcastStream();
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
      final list = await _service.getData(url: _typeUrl, page: _page);
      _cacheData.addAll(list);
      data.add(_cacheData.toList());
      _photoData.add(_cacheData.toList());
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

    data.close();
    _photoData.close();

    super.dispose();
  }
}
