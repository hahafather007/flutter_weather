import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class WebViewModel<T> extends ViewModel {
  final isFav = StreamController<bool>();

  final _favHolder = FavHolder();

  WebViewModel({@required T favData}) {
    if (favData == null) return;

    isFav.safeAdd(_favHolder.isFavorite(favData));
    isLoading.safeAdd(true);
    _favHolder.favReadStream
        .listen((_) => isFav.safeAdd(_favHolder.isFavorite(favData)))
        .bindLife(this);
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
