import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/egg_data.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/gift_egg_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftEggViewModel extends ViewModel {
  final data = StreamController<EggData>();

  final _service = GiftEggService();
  final _photoData = StreamController<List<MziItem>>();

  EggData _cacheData;
  Stream<List<MziItem>> photoStream;

  GiftEggViewModel() {
    photoStream = _photoData.stream.asBroadcastStream();
  }

  Future<void> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    if (_cacheData != null && _cacheData.currentPage >= _cacheData.pageCount)
      return;

    selfLoading = true;
    if (type != LoadType.REFRESH) {
      isLoading.safeAdd(true);
    }

    try {
      final egg = await _service.getData(
          page: (type == LoadType.REFRESH || type == LoadType.NEW_LOAD)
              ? 1
              : (_cacheData?.currentPage ?? 0) + 1);

      if (type == LoadType.REFRESH || type == LoadType.NEW_LOAD) {
        _cacheData = egg;
      } else {
        _cacheData?.currentPage = egg.currentPage;
        _cacheData?.pageCount = egg.pageCount;
        _cacheData?.comments?.addAll(egg.comments);
      }

      data.safeAdd(_cacheData);
      _photoData.safeAdd(_cacheData?.comments
          ?.map((v) => v?.pics?.isNotEmpty == true
              ? v.pics.first
              : "https://www.baidu.com/img/bd_logo1.png")
          ?.map(
              (v) => MziItem(height: 459, width: 337, url: v, isImages: false))
          ?.toList());
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

    data.close();
    _photoData.close();

    super.dispose();
  }
}
