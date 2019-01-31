import 'package:flutter_weather/commom_import.dart';

class WebViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();

  List<String> openingUrls = List();

  WebViewModel({@required T favData}) {
    isFav.add(_favHolder.isFavorite(favData));
    isLoading.add(true);
    bindSub(_favHolder.favReadStream
        .listen((_) => isFav.add(_favHolder.isFavorite(favData))));
  }

  void bindEvent(Stream eventStream) {
    bindSub(eventStream.listen((event) {
      debugPrint(event.toString());
      switch (event["event"]) {
        case "onPageStarted":
          isLoading.add(true);
          openingUrls.add(event["url"]);
          break;
        case "onPageFinished":
          openingUrls.remove(event["url"]);
          if (openingUrls.isEmpty) {
            isLoading.add(false);
          }
          break;
      }
    }));
  }

  @override
  void dispose() {
    openingUrls.clear();

    isFav.close();

    super.dispose();
  }
}
