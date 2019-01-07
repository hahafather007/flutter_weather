import 'package:flutter_weather/commom_import.dart';

class WebViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();

  WebViewModel({@required T favData}) {
    isFav.add(_favHolder.isFavorite(favData));
    bindSub(_favHolder.favReadStream
        .listen((_) => isFav.add(_favHolder.isFavorite(favData))));
  }

  @override
  void dispose() {
    isFav.close();

    super.dispose();
  }
}
