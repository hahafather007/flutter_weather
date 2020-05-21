import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftPhotoWatchViewModel<T> extends ViewModel {
  final favList = StreamController<List<MziItem>>();
  final data = StreamController<List<MziItem>>();

  GiftPhotoWatchViewModel({@required Stream<List<MziItem>> photoStream}) {
    FavHolder().favMziStream.listen((v) => favList.safeAdd(v)).bindLife(this);

    if (photoStream != null) {
      photoStream.listen((v) => data.safeAdd(v)).bindLife(this);
    }

    favList.safeAdd(FavHolder().favMzis);
  }

  @override
  void dispose() {
    data.close();
    favList.close();

    super.dispose();
  }
}
