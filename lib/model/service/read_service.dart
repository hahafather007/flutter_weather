import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/service/service.dart';
import 'package:flutter_weather/utils/log_util.dart';

class ReadService extends Service {
  ReadService() {
    dio.options.baseUrl = "https://gank.io/api/v2";
  }

  /// 获取所有文章子分类
  Future<List<ReadTitle>> getTitles() async {
    final response = await get("/categories/Article", cancelToken: cancelToken);

    debugLog(response);

    final Map map = response.data;
    if (map != null && map["data"] != null) {
      return (map["data"] as List).map((v) => ReadTitle.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  /// 获取文章列表数据
  Future<ReadData> getReadData(
      {@required String type, @required int page}) async {
    final response = await get(
        "/data/category/GanHuo/type/$type/page/$page/count/20",
        cancelToken: cancelToken);

    debugLog(response);

    return ReadData.fromJson(response.data);
  }
}
