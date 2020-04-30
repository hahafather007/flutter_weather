import 'dart:async';

import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class FavGiftsViewModel extends ViewModel {
  final data = StreamController<List<MziData>>();

  FavGiftsViewModel() {
    FavHolder()
        .favMziStream
        .map((list) => list.where((v) => v.isImages).toList())
        .listen(data.safeAdd)
        .bindLife(this);

    data.safeAdd(FavHolder().favMzis.where((v) => v.isImages).toList());
  }

  @override
  void dispose() {
    data.close();

    super.dispose();
  }
}
