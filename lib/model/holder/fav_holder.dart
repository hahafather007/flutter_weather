import 'package:flutter_weather/commom_import.dart';

class FavHolder<T> {
  static final FavHolder _holder = FavHolder._internal();

  factory FavHolder() => _holder;

  final List<ReadData> _cacheReads = List();
  final _favReadBroadcast = StreamController<List<ReadData>>();
  Stream<List<ReadData>> favReadStream;

  FavHolder._internal() {
    favReadStream = _favReadBroadcast.stream.asBroadcastStream();

    final readValue = SharedDepository().favReadData;
    if (readValue != null) {
      final list =
          (json.decode(readValue) as List).map((v) => ReadData.fromJson(v));
      _cacheReads.addAll(list);
    }
    _favReadBroadcast.add(_cacheReads.toList());
  }

  /// 添加或取消收藏
  void autoFav(T t) {
    if (t is ReadData) {
      if (isFavorite(t)) {
        _cacheReads.removeWhere((v) => v.url == t.url);
      } else {
        _cacheReads.add(t);
      }

      SharedDepository()
          .setFavReadData(json.encode(_cacheReads))
          .then((_) => _favReadBroadcast.add(_cacheReads.toList()));
    }
  }

  /// 判断[t]是否被收藏
  bool isFavorite(T t) {
    if (t is ReadData) {
      return _cacheReads.any((v) => v.url == t.url);
    }

    return false;
  }

  void dispose() {
    _cacheReads.clear();
    _favReadBroadcast.close();
  }
}
