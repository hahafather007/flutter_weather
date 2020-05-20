import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class WebViewModel<T> extends ViewModel {
  final isFav = StreamController<bool>();

  WebViewModel({@required T favData}) {
    if (favData == null) return;

    FavHolder()
        .favReadStream
        .listen((_) => isFav.safeAdd(FavHolder().isFavorite(favData)))
        .bindLife(this);

    isFav.safeAdd(FavHolder().isFavorite(favData));
    isLoading.safeAdd(true);
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
