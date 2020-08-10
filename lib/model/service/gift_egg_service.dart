import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/egg_data.dart';
import 'package:flutter_weather/model/service/service.dart';

class GiftEggService extends Service {
  GiftEggService() {
    dio.options.baseUrl = "http://i.jandan.net";
  }

  Future<EggData> getData({@required int page}) async {
    final response = await get(
        "/?oxwlxojflwblxbsapi=jandan.get_ooxx_comments&page=$page",
        cancelToken: cancelToken);

    final egg = await compute(_formatEgg, response.data);
    if (egg.status != "ok") {
      throw DioError(error: "我也不知为什么，它就是出错了");
    } else {
      return egg;
    }
  }

  static EggData _formatEgg(data) {
    return EggData.fromJson(data);
  }
}
