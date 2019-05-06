import 'package:flutter_weather/commom_import.dart';

class WebViewModel<T> extends ViewModel {
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();

  int openingNum = 0;

  WebViewModel({@required T favData}) {
    if (favData == null) return;

    streamAdd(isFav, _favHolder.isFavorite(favData));
    streamAdd(isLoading, true);
    bindSub(_favHolder.favReadStream
        .listen((_) => streamAdd(isFav, _favHolder.isFavorite(favData))));
  }

  void bindEvent(Stream eventStream) {
    bindSub(eventStream.listen((event) {
      debugPrint(event.toString());

      if (isAndroid) {
        switch (event["event"]) {
          case "onPageStarted":
            streamAdd(isLoading, true);
            openingNum++;
            break;
          case "onPageFinished":
            openingNum--;
            if (openingNum <= 0) {
              streamAdd(isLoading, false);
            }
            break;
          case "shouldOverrideUrlLoading":
            if (openingNum > 0) {
              openingNum--;
            }
            break;
        }
      } else {
        switch (event["event"]) {
          case "didStart":
            streamAdd(isLoading, true);
            openingNum++;
            break;
          case "didFinish":
            openingNum--;
            if (openingNum <= 0) {
              streamAdd(isLoading, false);
            }
            break;
          case "didStartProvisionalNavigation":
            if (openingNum > 0) {
              openingNum--;
            }
            break;
        }
      }
    }));
  }

  @override
  void dispose() {
    isFav.close();

    super.dispose();
  }
}
