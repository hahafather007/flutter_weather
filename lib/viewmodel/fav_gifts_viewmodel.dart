import 'dart:async';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class FavGiftsViewModel extends ViewModel {
  final data = StreamController<List<MziData>>();

  FavGiftsViewModel() {
    bindSub(FavHolder().favMziStream.listen(
        (list) => data.safeAdd(list.where((v) => v.isImages).toList())));
    data.safeAdd(FavHolder().favMzis.where((v) => v.isImages).toList());
  }

  @override
  void dispose() {
    data.close();

    super.dispose();
  }
}
