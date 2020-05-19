import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/gank_data.dart';
import 'package:flutter_weather/model/service/gank_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

/// 所有Gank通用
class GankViewModel extends ViewModel {
  final data = StreamController<GankData>();

  final _service = GankService();

  GankData _cacheData;
  String _type;
  String _category;

  void init({@required String category, @required String type}) {
    _type = type;
    _category = category;
    loadData(type: LoadType.NEW_LOAD);
  }

  Future<void> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    if (_cacheData != null && _cacheData.page >= _cacheData.pageCount) return;

    selfLoading = true;

    if (type != LoadType.REFRESH) {
      isLoading.safeAdd(true);
    }

    try {
      final readData = await _service.getGankData(
          category: _category,
          type: _type,
          page: (type == LoadType.REFRESH || type == LoadType.NEW_LOAD)
              ? 1
              : (_cacheData?.page ?? 0) + 1);

      if (type == LoadType.REFRESH || type == LoadType.NEW_LOAD) {
        _cacheData = readData;
      } else {
        _cacheData?.page = readData.page;
        _cacheData?.pageCount = readData.pageCount;
        _cacheData?.data?.addAll(readData.data);
      }

      data.safeAdd(_cacheData);
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

    data.close();

    super.dispose();
  }
}
