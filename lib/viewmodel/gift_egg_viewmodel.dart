import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/gift_egg_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftEggViewModel extends ViewModel {
  final data = StreamController<List<MziItem>>();

  final _service = GiftEggService();
  final _photoData = StreamController<List<MziItem>>();
  final _cacheData = List<MziItem>();

  Stream<List<MziItem>> photoStream;
  int _page = 1;

  GiftEggViewModel() {
    photoStream = _photoData.stream.asBroadcastStream();
  }

  Future<void> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type == LoadType.REFRESH) {
      _page = 1;
      _cacheData.clear();
    } else {
      isLoading.safeAdd(true);
    }

    try {
      final egg = await _service.getData(page: _page);
      egg.comments.forEach((v) {
        _cacheData.addAll(v.pics.map((url) =>
            MziItem(height: 459, width: 337, url: url, isImages: false)));
      });
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
