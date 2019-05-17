import 'package:flutter_weather/commom_import.dart';

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
