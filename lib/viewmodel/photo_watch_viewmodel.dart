import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class PhotoWatchViewModel<T> extends ViewModel {
  final favList = StreamController<List<MziData>>();
  final data = StreamController<List<MziData>>();

  PhotoWatchViewModel({@required Stream<List<MziData>> photoStream}) {
    streamAdd(favList, FavHolder().favMzis);
    bindSub(FavHolder().favMziStream.listen((v) => streamAdd(favList, v)));
    if (photoStream != null) {
      bindSub(photoStream.listen((v) => streamAdd(data, v)));
    }
  }

  @override
  void dispose() {
    data.close();
    favList.close();

    super.dispose();
  }
}
