import 'dart:async';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class FavGiftViewModel extends ViewModel {
  final data = StreamController<List<MziData>>();

  FavGiftViewModel() {
    bindSub(FavHolder().favMziStream.listen(
        (list) => streamAdd(data, list.where((v) => !v.isImages).toList())));
    streamAdd(data, FavHolder().favMzis.where((v) => !v.isImages).toList());
  }

  @override
  void dispose() {
    data.close();

    super.dispose();
  }
}
