import 'package:flutter_weather/commom_import.dart';

class PhotoWatchViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final favList = StreamController<List<MziData>>();
  final data = StreamController<List<MziData>>();

  PhotoWatchViewModel({@required Stream<List<MziData>> photoStream}) {
    favList.add(_favHolder.favMzis);
    bindSub(_favHolder.favMziStream.listen(favList.add));
    bindSub(photoStream.listen((v) => data.add(v.toList())));
  }

  @override
  void dispose() {
    data.close();
    favList.close();

    super.dispose();
  }
}
