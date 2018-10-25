import 'package:flutter_weather/commom_import.dart';

class GiftEggService extends Service {
  GiftEggService() {
    dio.options.baseUrl = "http://i.jandan.net";
  }

  Future<EggData> getData({@required int page}) async {
    final response =
        await dio.get("/?oxwlxojflwblxbsapi=jandan.get_ooxx_comments&=$page");

    return EggData.fromJson(response.data);
  }
}
