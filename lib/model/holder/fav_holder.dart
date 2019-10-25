import 'dart:async';
import 'dart:convert';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';

class FavHolder<T> {
  static final FavHolder _holder = FavHolder._internal();

  factory FavHolder() => _holder;

  final List<ReadData> _cacheReads = List();
  final List<MziData> _cacheMzis = List();
  final _favReadBroadcast = StreamController<List<ReadData>>();
  final _favMziBroadcast = StreamController<List<MziData>>();
  Stream<List<ReadData>> favReadStream;
  Stream<List<MziData>> favMziStream;

  FavHolder._internal() {
    favReadStream = _favReadBroadcast.stream.asBroadcastStream();
    favMziStream = _favMziBroadcast.stream.asBroadcastStream();

    _init();
  }

  void _init() async {
    final readValue = SharedDepository().favReadData;
    if (readValue != null) {
      final list =
          (jsonDecode(readValue) as List).map((v) => ReadData.fromJson(v));
      _cacheReads.addAll(list);
    }
    streamAdd(_favReadBroadcast, _cacheReads);

    final mziValue = SharedDepository().favMziData;
    if (mziValue != null) {
      final list =
          (json.decode(mziValue) as List).map((v) => MziData.fromJson(v));
      _cacheMzis.addAll(list);
    }
    streamAdd(_favMziBroadcast, _cacheMzis);
  }

  /// 添加或取消收藏
  void autoFav(T t) async {
    if (t == null) return;

    if (t is ReadData) {
      if (isFavorite(t)) {
        _cacheReads.removeWhere((v) => v.url == t.url);
      } else {
        _cacheReads.add(t);
      }

      streamAdd(_favReadBroadcast, _cacheReads);
      await SharedDepository().setFavReadData(json.encode(_cacheReads));
    } else if (t is MziData) {
      if (isFavorite(t)) {
        _cacheMzis
            .removeWhere((v) => v.url == t.url && v.isImages == t.isImages);
      } else {
        _cacheMzis.add(t);
      }

      streamAdd(_favMziBroadcast, _cacheMzis);
      await SharedDepository().setFavMziData(json.encode(_cacheMzis));
    }
  }

  List<MziData> get favMzis => _cacheMzis;

  List<ReadData> get favReads => _cacheReads;

  /// 判断[t]是否被收藏
  bool isFavorite(T t) {
    if (t is ReadData) {
      return _cacheReads.any((v) => v.url == t.url);
    } else if (t is MziData) {
      return _cacheMzis.any((v) => v.url == t.url && v.isImages == t.isImages);
    }

    return false;
  }

  void dispose() {
    _cacheReads.clear();
    _favReadBroadcast.close();
    _favMziBroadcast.close();
  }
}
