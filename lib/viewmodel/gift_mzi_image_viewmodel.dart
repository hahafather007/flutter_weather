import 'package:flutter_weather/commom_import.dart';

class GiftMziImageViewModel extends ViewModel {
  final _service = GiftMziImageService();

  final data = StreamController<List<MziData>>();
  final dataLength = StreamController<int>();
  final _photoData = StreamController<List<MziData>>();

  Stream<List<MziData>> photoStream;

  GiftMziImageViewModel() {
    photoStream = _photoData.stream.asBroadcastStream();
  }

  Future<Null> loadData({@required String link}) async {
    if (selfLoading) return;

    selfLoading = true;
    isLoading.add(true);
    try {
      final length = await _service.getLength(link: link);
      debugPrint("length======>$length");
      dataLength.add(length);
      final List<MziData> list = List();
      for (int i = 1; i <= length; i++) {
        list.add(await _service.getData(link: link, index: i));

        if (data.isClosed) return;
        data.add(list);
        _photoData.add(list);
      }
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;
      if (!isLoading.isClosed) {
        isLoading.add(false);
      }
    }
  }

  @override
  void dispose() {
    _service.dispose();

    data.close();
    dataLength.close();
    _photoData.close();

    super.dispose();
  }
}
