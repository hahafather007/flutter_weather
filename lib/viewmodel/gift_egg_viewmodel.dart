import 'package:flutter_weather/commom_import.dart';
import 'package:dio/dio.dart';

class GiftEggViewModel extends ViewModel {
  final _service = GiftEggService();

  final data = StreamController<List<MziData>>();
  final _photoData = StreamController<List<MziData>>();

  Stream<List<MziData>> photoStream;
  List<MziData> _cacheData = List();
  int _page = 1;

  GiftEggViewModel() {
    photoStream = _photoData.stream.asBroadcastStream();
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
      final egg = await _service.getData(page: _page);
      egg.comments.forEach((v) {
        _cacheData.addAll(v.pics.map((url) =>
            MziData(height: 459, width: 337, url: url, isImages: false)));
      });
      streamAdd(data, _cacheData);
      streamAdd(_photoData, _cacheData);
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
    _photoData.close();

    super.dispose();
  }
}
