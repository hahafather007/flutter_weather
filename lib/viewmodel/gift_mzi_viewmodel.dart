import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/gift_mzi_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftMziViewModel extends ViewModel {
  final data = StreamController<List<MziItem>>();

  final _service = GiftMziService();

  String _typeUrl;
  MziData _cacheData;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
    loadData(type: LoadType.NEW_LOAD);
  }

  Future<void> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    if (_cacheData != null && _cacheData.page >= _cacheData.maxPage) return;

    selfLoading = true;
    if (type != LoadType.REFRESH) {
      isLoading.safeAdd(true);
    }

    try {
      final mziData = await _service.getImageList(
          url: _typeUrl,
          page: (type == LoadType.REFRESH || type == LoadType.NEW_LOAD)
              ? 1
              : (_cacheData?.page ?? 0) + 1);

      if (type == LoadType.REFRESH || type == LoadType.NEW_LOAD) {
        _cacheData = mziData;
      } else {
        _cacheData?.page = mziData.page;
        _cacheData?.maxPage = mziData.maxPage;
        _cacheData?.items?.addAll(mziData.items);
      }

      data.add(_cacheData.items);
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
