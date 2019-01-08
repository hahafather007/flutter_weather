import 'package:flutter_weather/commom_import.dart';

class PhotoWatchViewModel extends ViewModel {
  final data = StreamController<List<MziData>>();

  void init(Stream<List<MziData>> photoStream) {
    bindSub(photoStream.listen(data.add));
  }

  @override
  void dispose() {
    data.close();

    super.dispose();
  }
}
