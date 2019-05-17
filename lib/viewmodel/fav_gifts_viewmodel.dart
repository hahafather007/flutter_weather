import 'package:flutter_weather/commom_import.dart';

class FavGiftsViewModel extends ViewModel {
  final data = StreamController<List<MziData>>();

  FavGiftsViewModel() {
    bindSub(FavHolder().favMziStream.listen(
        (list) => streamAdd(data, list.where((v) => v.isImages).toList())));
    streamAdd(data, FavHolder().favMzis.where((v) => v.isImages).toList());
  }

  /// 删除收藏
  void removeRead(MziData data) {
    FavHolder().autoFav(data);
  }

  @override
  void dispose() {
    data.close();

    super.dispose();
  }
}
