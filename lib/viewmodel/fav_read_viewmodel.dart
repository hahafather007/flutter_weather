import 'package:flutter_weather/commom_import.dart';

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
