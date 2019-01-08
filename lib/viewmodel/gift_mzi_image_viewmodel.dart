import 'package:flutter_weather/commom_import.dart';

class GiftMziImageViewModel extends ViewModel {
  final _service = GiftMziImageService();

  Future<Null> loadData({@required String link}) async {
    if (selfLoading) return;

    selfLoading = true;
    isLoading.add(true);
    try {
      final length = await _service.getLength(link: link);
      debugPrint("length======>$length");
      for (int i = 1; i <= length; i++) {
        await _service.getData(link: link, index: i);
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

    super.dispose();
  }
}
