import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/model/service/gift_mzi_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftMziImageViewModel extends ViewModel {
  final isFav = StreamController<bool>();
  final data = StreamController<List<MziItem>>();
  final dataLength = StreamController<int>();
  final photoStream = StreamController<List<MziItem>>();

  final _service = GiftMziService();
  final _cacheData = List<MziItem>();

  MziItem _mziData;

  GiftMziImageViewModel({@required MziItem data}) {
    _mziData = data;

    FavHolder()
        .favMziStream
        .listen((_) => isFav.safeAdd(FavHolder().isFavorite(data)))
        .bindLife(this);

    isFav.safeAdd(FavHolder().isFavorite(data));
  }

  Future<void> loadData() async {
    if (selfLoading) return;

    selfLoading = true;
    isLoading.safeAdd(true);
    try {
      final length = await _service.getLength(link: _mziData.link);
      dataLength.safeAdd(length);

      for (int i = _cacheData.length + 1; i <= length; i++) {
        _cacheData
            .add(await _service.getEachData(link: _mziData.link, index: i));

        data.safeAdd(_cacheData);
        photoStream.safeAdd(_cacheData);
      }
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.safeAdd(false);
    }
  }

  @override
  void reload() {
    super.reload();

    loadData();
  }

  @override
  void dispose() {
    _service.dispose();
    _cacheData.clear();

    data.close();
    isFav.close();
    dataLength.close();
    photoStream.close();

    super.dispose();
  }
}
