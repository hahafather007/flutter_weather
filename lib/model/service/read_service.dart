import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/service/service.dart';
import 'package:html/parser.dart';

class ReadService extends Service {
  ReadService() {
    dio.options.baseUrl = "https://gank.io/api/v2";
  }

  Future<List<ReadTitle>> getTitles()async{
    final response =
        await dio.get("/categories/Article", cancelToken: cancelToken);
  }

  Future<List<ReadData>> getReadList(
      {@required String lastUrl, @required int page}) async {
    final response =
        await dio.get("/xiandu/$lastUrl/page/$page", cancelToken: cancelToken);

    // 解析xml
    final document = parse(response.data);
    final total = document.getElementsByClassName("xiandu_items").first;
    final items = total.getElementsByClassName("xiandu_item");

    final list = items.map((item) {
      final left = item.getElementsByClassName("xiandu_left").first;
      final right = item.getElementsByClassName("xiandu_right").first;

      final data = ReadData();
      data.name = left.querySelector("a[href]").text;
      data.from = right.querySelector("a").attributes["title"];
      data.updateTime = left
          .querySelector("small")
          .text
          .replaceAll(" ", "")
          .replaceAll("\n", "");
      data.url = left.querySelector("a[href]").attributes["href"];
      data.icon = right.querySelector("img").attributes["src"];

      return data;
    }).toList();

    debugPrint("========>${list.length}");

    return list;
  }
}
