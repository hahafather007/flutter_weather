import 'package:flutter_weather/commom_import.dart';
import 'package:dio/dio.dart';

class ReadViewModel extends ViewModel {
  final _service = ReadService();

  final data = StreamController<List<ReadData>>();

  List<ReadData> _cacheData = List();
  bool selfLoading = false;
  int _page = 1;
  String _typeUrl;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
    loadData(type: LoadType.NEW_LOAD);
  }

  Future<Null> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type == LoadType.REFRESH) {
      _page = 1;
      _cacheData.clear();
    } else {
      streamAdd(isLoading, true);
    }

    try {
      final list = await _service.getReadDatas(lastUrl: _typeUrl, page: _page);

      _cacheData.addAll(list);
      streamAdd(data, _cacheData);
      _page++;
    } on DioError catch (e) {
      selfLoadType = type;
      doError(e);
    } finally {
      selfLoading = false;
      streamAdd(isLoading, false);
    }
  }

  void reload() {
    loadData(type: selfLoadType);
  }

  void loadMore() {
    loadData(type: LoadType.LOAD_MORE);
  }

  @override
  void dispose() {
    _service.dispose();
    _cacheData.clear();

    data.close();

    super.dispose();
  }
}
