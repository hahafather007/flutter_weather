import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/gift_gank_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftGankViewModel extends ViewModel {
  final data = StreamController<List<MziItem>>();

  final _service = GiftGankService();
  final _photoData = StreamController<List<MziItem>>();
  final _cacheData = List<MziItem>();

  Stream<List<MziItem>> photoStream;
  int _page = 1;

  GiftGankViewModel() {
    photoStream = _photoData.stream.asBroadcastStream();
  }

  Future<void> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type != LoadType.REFRESH) {
      isLoading.safeAdd(true);
    }

    try {
      final list = await _service.getImageList(
          page: (type == LoadType.REFRESH || type == LoadType.NEW_LOAD)
              ? 1
              : _page);
      if (type == LoadType.REFRESH || type == LoadType.NEW_LOAD) {
        _cacheData.clear();
        _page = 1;
      }

      _cacheData.addAll(list);
      data.safeAdd(_cacheData);
      _photoData.safeAdd(_cacheData);
      _page++;
    } on DioError catch (e) {
      selfLoadType = type;
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.safeAdd(false);
    }
  }

  @override
  void reload() {
    super.reload();

    loadData(type: selfLoadType);
  }

  @override
  void loadMore() {
    super.loadMore();

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
