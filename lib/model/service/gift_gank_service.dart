import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/service.dart';

class GiftGankService extends Service {
  GiftGankService() {
    dio.options.baseUrl = "http://gank.io";
  }

  Future<List<MziData>> getData({int page}) async {
    final response = await dio.get("/api/data/%E7%A6%8F%E5%88%A9/20/$page",
        cancelToken: cancelToken);

    debugPrint(response.toString());

    final map = response.data;
    if (map["error"]) {
      throw DioError(error: "我也不知为什么，它就是出错了");
    } else {
      return (map["results"] as List)
          .map((v) =>
              MziData(height: 459, width: 337, url: v["url"], isImages: false))
          .toList();
    }
  }
}
