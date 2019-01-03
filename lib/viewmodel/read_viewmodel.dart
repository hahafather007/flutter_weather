import 'package:flutter_weather/commom_import.dart';

class ReadViewModel extends ViewModel {
  final _service = ReadService();

  final datas = StreamController<List<ReadData>>();

  List<ReadData> _cacheData = List();
  bool selfLoading = false;
  int _page = 1;
  String _typeUrl;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
    loadData(isRefresh: false);
  }

  Future<Null> loadData(
      {bool isRefresh = true, bool isLoadMore = false}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (!isRefresh) {
      if (!isLoadMore) {
        isLoading.add(true);
      }
    } else {
      _page = 1;
      _cacheData.clear();
    }

    try {
      final list = await _service.getReadDatas(lastUrl: _typeUrl, page: _page);

      _cacheData.addAll(list);
      datas.add(_cacheData.toList());
      _page++;
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;

      if (!isRefresh) {
        isLoading.add(false);
      }
    }
  }

  void loadMore() {
    loadData(isRefresh: false, isLoadMore: true);
  }

  @override
  void dispose() {
    _service.dispose();
    _cacheData.clear();

    datas.close();

    super.dispose();
  }
}
