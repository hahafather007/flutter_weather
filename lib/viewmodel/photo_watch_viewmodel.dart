import 'package:flutter_weather/commom_import.dart';

class PhotoWatchViewModel extends ViewModel {
  final datas = StreamController<List<MziData>>();

  void init(Stream<List<MziData>> photoStream) {
    bindSub(photoStream.listen(datas.add));
  }

  @override
  void dispose() {
    datas.close();

    super.dispose();
  }
}
