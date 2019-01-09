import 'package:flutter_weather/commom_import.dart';

class PhotoWatchViewModel<T> extends ViewModel {
  final data = StreamController<List<MziData>>();

  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();

  PhotoWatchViewModel(
      {@required T favData, @required Stream<List<MziData>> photoStream}) {
    isFav.add(_favHolder.isFavorite(favData));
    bindSub(_favHolder.favReadStream
        .listen((_) => isFav.add(_favHolder.isFavorite(favData))));
    bindSub(photoStream.listen((v) => data.add(v.toList())));
  }

  @override
  void dispose() {
    data.close();

    super.dispose();
  }
}
