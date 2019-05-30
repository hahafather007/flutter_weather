import 'package:flutter_weather/commom_import.dart';

class PhotoWatchViewModel<T> extends ViewModel {
  final favList = StreamController<List<MziData>>();
  final data = StreamController<List<MziData>>();

  PhotoWatchViewModel({@required Stream<List<MziData>> photoStream}) {
    streamAdd(favList, FavHolder().favMzis);
    bindSub(FavHolder().favMziStream.listen((v) => streamAdd(favList, v)));
    if (photoStream != null) {
      bindSub(photoStream.listen((v) => streamAdd(data, v)));
    }
  }

  @override
  void dispose() {
    data.close();
    favList.close();

    super.dispose();
  }
}
