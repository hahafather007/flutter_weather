import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/gank_data.dart';
import 'package:flutter_weather/model/service/service.dart';

class GankService extends Service {
  GankService() {
    dio.options.baseUrl = "https://gank.io/api/v2";
  }

  /// 获取所有子分类
  Future<List<GankTitle>> getTitles({@required String category}) async {
    final response =
        await get("/categories/$category", cancelToken: cancelToken);

    return await compute(_formatTitles, response.data);
  }

  static List<GankTitle> _formatTitles(data) {
    if (data != null && data["data"] != null) {
      return (data["data"] as List).map((v) => GankTitle.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  /// 获取列表数据
  Future<GankData> getGankData(
      {@required String category,
      @required String type,
      @required int page}) async {
    final response = await get(
        "/data/category/$category/type/$type/page/$page/count/15",
        cancelToken: cancelToken);

    return await compute(_formatGank, response.data);
  }

  static GankData _formatGank(data) {
    return GankData.fromJson(data);
  }
}
