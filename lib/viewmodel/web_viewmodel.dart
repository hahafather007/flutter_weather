import 'package:flutter_weather/commom_import.dart';

class WebViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();

  int openingNum = 0;

  WebViewModel({@required T favData}) {
    streamAdd(isFav, _favHolder.isFavorite(favData));
    streamAdd(isLoading, true);
    bindSub(_favHolder.favReadStream
        .listen((_) => streamAdd(isFav, _favHolder.isFavorite(favData))));
  }

  void bindEvent(Stream eventStream) {
    bindSub(eventStream.listen((event) {
      debugPrint(event.toString());
      switch (event["event"]) {
        case "onPageStarted":
          streamAdd(isLoading, true);
          openingNum++;
          break;
        case "onPageFinished":
          openingNum--;
          if (openingNum == 0) {
            streamAdd(isLoading, false);
          }
          break;
        case "shouldOverrideUrlLoading":
          openingNum--;
          break;
      }
    }));
  }

  @override
  void dispose() {
    isFav.close();

    super.dispose();
  }
}
