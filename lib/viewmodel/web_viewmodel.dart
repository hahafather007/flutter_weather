import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class WebViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();

  WebViewModel({@required T favData}) {
    if (favData == null) return;

    isFav.safeAdd(_favHolder.isFavorite(favData));
    isLoading.safeAdd(true);
    bindSub(_favHolder.favReadStream
        .listen((_) => isFav.safeAdd(_favHolder.isFavorite(favData))));
  }

  void setLoading(bool loading) {
    isLoading.safeAdd(loading);
  }

  @override
  void dispose() {
    isFav.close();

    super.dispose();
  }
}
