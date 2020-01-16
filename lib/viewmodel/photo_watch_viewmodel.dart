import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class PhotoWatchViewModel<T> extends ViewModel {
  final favList = StreamController<List<MziData>>();
  final data = StreamController<List<MziData>>();

  PhotoWatchViewModel({@required Stream<List<MziData>> photoStream}) {
    favList.safeAdd(FavHolder().favMzis);
    FavHolder().favMziStream.listen((v) => favList.safeAdd(v)).bindLife(this);
    if (photoStream != null) {
      photoStream.listen((v) => data.safeAdd(v)).bindLife(this);
    }
  }

  @override
  void dispose() {
    data.close();
    favList.close();

    super.dispose();
  }
}
