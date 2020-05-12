import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/gift_mzi_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftMziViewModel extends ViewModel {
  final data = StreamController<List<MziItem>>();

  final _service = GiftMziService();
  final _cacheData = List<MziItem>();

  int _page = 1;
  String _typeUrl;
  LoadType _reloadType = LoadType.NEW_LOAD;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
    loadData(type: LoadType.NEW_LOAD);
  }

  Future<void> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type != LoadType.REFRESH) {
      isLoading.safeAdd(true);
    }

    try {
      final list = await _service.getImageList(
          url: _typeUrl,
          page: (type == LoadType.REFRESH || type == LoadType.NEW_LOAD)
              ? 1
              : _page);
      if (type == LoadType.REFRESH || type == LoadType.NEW_LOAD) {
        _cacheData.clear();
        _page = 1;
      }

      _cacheData.addAll(list);
      data.add(_cacheData);
      _page++;
    } on DioError catch (e) {
      _reloadType = type;
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.safeAdd(false);
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

    super.dispose();
  }
}
