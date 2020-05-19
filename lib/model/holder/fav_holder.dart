import 'dart:async';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/data/gank_data.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';

class FavHolder {
  static final FavHolder _holder = FavHolder._internal();

  factory FavHolder() => _holder;

  final _favReadBroadcast = StreamController<List<GankItem>>();
  final _favMziBroadcast = StreamController<List<MziItem>>();
  final _cacheReads = List<GankItem>();
  final _cacheMzis = List<MziItem>();

  Stream<List<GankItem>> favReadStream;
  Stream<List<MziItem>> favMziStream;

  List<MziItem> get favMzis => _cacheMzis;

  List<GankItem> get favReads => _cacheReads;

  FavHolder._internal() {
    favReadStream = _favReadBroadcast.stream.asBroadcastStream();
    favMziStream = _favMziBroadcast.stream.asBroadcastStream();

    _init();
  }

  void _init() {
    _cacheReads.addAll(SharedDepository().favReadItems);
    _favReadBroadcast.safeAdd(_cacheReads);
    _cacheMzis.addAll(SharedDepository().favMziItems);
    _favMziBroadcast.safeAdd(_cacheMzis);
  }

  /// 添加或取消收藏
  Future<void> autoFav(dynamic data) async {
    if (data == null) return;

    if (data is GankItem) {
      if (isFavorite(data)) {
        _cacheReads.removeWhere((v) => v.sId == data.sId);
      } else {
        _cacheReads.add(data);
      }

      _favReadBroadcast.safeAdd(_cacheReads);
      SharedDepository().setFavReadItems(_cacheReads);
    } else if (data is MziItem) {
      if (isFavorite(data)) {
        _cacheMzis.removeWhere(
            (v) => v.url == data.url && v.isImages == data.isImages);
      } else {
        _cacheMzis.add(data);
      }

      _favMziBroadcast.safeAdd(_cacheMzis);
      SharedDepository().setFavMziItems(_cacheMzis);
    }
  }

  /// 判断[data]是否被收藏
  bool isFavorite(dynamic data) {
    if(data == null){
      return false;
    }

    if (data is GankItem) {
      return _cacheReads.any((v) => v.sId == data.sId);
    } else if (data is MziItem) {
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
