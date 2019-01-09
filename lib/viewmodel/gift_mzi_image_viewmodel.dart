import 'package:flutter_weather/commom_import.dart';

class GiftMziImageViewModel extends ViewModel {
  final _service = GiftMziImageService();
  final _favHolder = FavHolder();

  final isFav = StreamController<bool>();
  final data = StreamController<List<MziData>>();
  final dataLength = StreamController<int>();
  final _photoData = StreamController<List<MziData>>();

  Stream<List<MziData>> photoStream;

  GiftMziImageViewModel({@required MziData data}) {
    photoStream = _photoData.stream.asBroadcastStream();
    isFav.add(_favHolder.isFavorite(data));
    bindSub(_favHolder.favReadStream
        .listen((_) => isFav.add(_favHolder.isFavorite(data))));
  }

  Future<Null> loadData({@required MziData data}) async {
    if (selfLoading) return;

    selfLoading = true;
    isLoading.add(true);
    try {
      final length = await _service.getLength(link: data.link);
      debugPrint("length======>$length");
      dataLength.add(length);
      final List<MziData> list = List();
      for (int i = 1; i <= length; i++) {
        list.add(await _service.getData(link: data.link, index: i));

        if (this.data.isClosed) return;
        this.data.add(list);
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
    isFav.close();
    dataLength.close();
    _photoData.close();

    super.dispose();
  }
}
