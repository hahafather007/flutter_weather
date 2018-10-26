import 'package:flutter_weather/commom_import.dart';

class GiftMziService extends Service {
  final xml2Json = Xml2Json();

  GiftMziService() {
    dio.options.baseUrl = "http://www.mzitu.com";
  }

  Future<Null> getData({@required String url, @required int page}) async {
    final response = await dio.get("$url/$page");

    debugPrint("===========Before===========");
    debugPrint(response.toString());

    xml2Json.parse(response.data);

    debugPrint("===========After===========");
    debugPrint(response.toString());
  }
}
