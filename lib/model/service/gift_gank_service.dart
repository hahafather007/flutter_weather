import 'package:flutter_weather/commom_import.dart';

class GiftGankService extends Service {
  GiftGankService() {
    dio.options.baseUrl = "http://gank.io";
  }

  Future<List<MziData>> getData({int page}) async {
    final response = await dio.get("/api/data/%E7%A6%8F%E5%88%A9/20/$page");

    debugPrint(response.toString());

    final map = response.data;
    if (map["error"]) {
      throw DioError(message: "我也不知为什么，它就是出错了");
    } else {
      final List list = map["results"];

      return list
          .map((v) =>
              MziData(height: 16, width: 9, url: v["url"], isImages: false))
          .toList();
    }
  }
}
