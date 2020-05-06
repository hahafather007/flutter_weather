import 'dart:async';

import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class FavReadViewModel extends ViewModel {
  final items = StreamController<List<ReadItem>>();

  FavReadViewModel() {
    FavHolder().favReadStream.listen(items.safeAdd).bindLife(this);

    items.safeAdd(FavHolder().favReads);
  }

  /// 删除收藏
  void removeRead(ReadItem data) {
    FavHolder().autoFav(data);
  }

  @override
  void dispose() {
    items.close();

    super.dispose();
  }
}
