import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/model/service/gift_mzi_image_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftMziImageViewModel extends ViewModel {
  final _service = GiftMziImageService();
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();
  final data = StreamController<List<MziData>>();
  final dataLength = StreamController<int>();
  final _photoData = StreamController<List<MziData>>();

  MziData _mziData;

  Stream<List<MziData>> photoStream;

  GiftMziImageViewModel({@required MziData data}) {
    _mziData = data;
    photoStream = _photoData.stream.asBroadcastStream();
    streamAdd(isFav, _favHolder.isFavorite(data));
    bindSub(_favHolder.favMziStream
        .listen((_) => streamAdd(isFav, _favHolder.isFavorite(data))));
  }

  Future<Null> loadData() async {
    if (selfLoading) return;

    selfLoading = true;
    streamAdd(isLoading, true);
    try {
      final length = await _service.getLength(link: _mziData.link);
      debugPrint("length======>$length");
      streamAdd(dataLength, length);
      final List<MziData> list = List();
      for (int i = 1; i <= length; i++) {
        list.add(await _service.getData(link: _mziData.link, index: i));

        streamAdd(data, list);
        streamAdd(_photoData, list);
      }
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;
      streamAdd(isLoading, false);
    }
  }

  @override
  void dispose() {
    _service.dispose();

    data.close();
    isFav.close();
    dataLength.close();
    _photoData.close();

    super.dispose();
  }
}
