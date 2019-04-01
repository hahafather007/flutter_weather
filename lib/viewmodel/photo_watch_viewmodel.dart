import 'package:flutter_weather/commom_import.dart';

class PhotoWatchViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final favList = StreamController<List<MziData>>();
  final data = StreamController<List<MziData>>();

  PhotoWatchViewModel({@required Stream<List<MziData>> photoStream}) {
    streamAdd(favList, _favHolder.favMzis);
    bindSub(_favHolder.favMziStream.listen((v) => streamAdd(favList, v)));
    bindSub(photoStream.listen((v) => streamAdd(data, v)));
  }

  @override
  void dispose() {
    data.close();
    favList.close();

    super.dispose();
  }
}
