import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/gift_gank_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftGankViewModel extends ViewModel {
  final _service = GiftGankService();

  final data = StreamController<List<MziData>>();
  final _photoData = StreamController<List<MziData>>();

  Stream<List<MziData>> photoStream;
  List<MziData> _cacheData = List();
  int _page = 1;

  GiftGankViewModel() {
    photoStream = _photoData.stream.asBroadcastStream();
  }

  Future<Null> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type == LoadType.REFRESH) {
      _page = 1;
      _cacheData.clear();
    } else {
      isLoading.safeAdd(true);
    }

    try {
      final list = await _service.getData(page: _page);
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
