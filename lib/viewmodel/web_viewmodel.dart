import 'package:flutter_weather/commom_import.dart';

class WebViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();

  WebViewModel({@required T favData}) {
    if (favData == null) return;

    streamAdd(isFav, _favHolder.isFavorite(favData));
    streamAdd(isLoading, true);
    bindSub(_favHolder.favReadStream
        .listen((_) => streamAdd(isFav, _favHolder.isFavorite(favData))));
  }

  void setLoading(bool loading) {
    streamAdd(isLoading, loading);
  }

  @override
  void dispose() {
    isFav.close();

    super.dispose();
  }
}
