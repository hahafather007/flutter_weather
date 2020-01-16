import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/gift_mzi_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftMziViewModel extends ViewModel {
  final _service = GiftMziService();

  final data = StreamController<List<MziData>>();

  List<MziData> _cacheData = List();
  int _page = 1;
  String _typeUrl;
  LoadType _reloadType = LoadType.NEW_LOAD;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
    loadData(type: LoadType.NEW_LOAD);
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
      final list = await _service.getData(url: _typeUrl, page: _page);
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
