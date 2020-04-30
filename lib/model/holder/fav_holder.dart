import 'dart:async';
import 'dart:convert';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';

class FavHolder {
  static final FavHolder _holder = FavHolder._internal();

  factory FavHolder() => _holder;

  final _favReadBroadcast = StreamController<List<ReadData>>();
  final _favMziBroadcast = StreamController<List<MziData>>();
  final _cacheReads = List<ReadData>();
  final _cacheMzis = List<MziData>();

  Stream<List<ReadData>> favReadStream;
  Stream<List<MziData>> favMziStream;

  List<MziData> get favMzis => _cacheMzis;

  List<ReadData> get favReads => _cacheReads;

  FavHolder._internal() {
    favReadStream = _favReadBroadcast.stream.asBroadcastStream();
    favMziStream = _favMziBroadcast.stream.asBroadcastStream();

    _init();
  }

  void _init() {
    final readValue = SharedDepository().favReadData;
    if (readValue != null) {
      final list =
          (jsonDecode(readValue) as List).map((v) => ReadData.fromJson(v));
      _cacheReads.addAll(list);
    }
    _favReadBroadcast.safeAdd(_cacheReads);

    final mziValue = SharedDepository().favMziData;
    if (mziValue != null) {
      final list =
          (json.decode(mziValue) as List).map((v) => MziData.fromJson(v));
      _cacheMzis.addAll(list);
    }
    _favMziBroadcast.safeAdd(_cacheMzis);
  }

  /// 添加或取消收藏
  Future<void> autoFav(dynamic data) async {
    if (data == null) return;

    if (data is ReadData) {
      if (isFavorite(data)) {
        _cacheReads.removeWhere((v) => v.url == data.url);
      } else {
        _cacheReads.add(data);
      }

      _favReadBroadcast.safeAdd(_cacheReads);
      await SharedDepository().setFavReadData(json.encode(_cacheReads));
    } else if (data is MziData) {
      if (isFavorite(data)) {
        _cacheMzis.removeWhere(
            (v) => v.url == data.url && v.isImages == data.isImages);
      } else {
        _cacheMzis.add(data);
      }

      _favMziBroadcast.safeAdd(_cacheMzis);
      await SharedDepository().setFavMziData(json.encode(_cacheMzis));
    }
  }

  /// 判断[data]是否被收藏
  bool isFavorite(dynamic data) {
    if (data is ReadData) {
      return _cacheReads.any((v) => v.url == data.url);
    } else if (data is MziData) {
      return _cacheMzis
          .any((v) => v.url == data.url && v.isImages == data.isImages);
    }

    return false;
  }

  void dispose() {
    _cacheReads.clear();
    _favReadBroadcast.close();
    _favMziBroadcast.close();
  }
}
