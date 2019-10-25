import 'dart:async';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class FavReadViewModel extends ViewModel {
  final data = StreamController<List<ReadData>>();

  FavReadViewModel() {
    bindSub(FavHolder().favReadStream.listen((list) => streamAdd(data, list)));
    streamAdd(data, FavHolder().favReads);
  }

  /// 删除收藏
  void removeRead(ReadData data) {
    FavHolder().autoFav(data);
  }

  @override
  void dispose() {
    data.close();

    super.dispose();
  }
}
