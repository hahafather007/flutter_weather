import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mixing.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/service.dart';
import 'package:html/parser.dart';

class GiftMziService extends Service {
  GiftMziService() {
    dio.options.baseUrl = "https://www.mzitu.com";
  }

  /// 获取列表数据
  Future<MziData> getImageList(
      {@required String url, @required int page}) async {
    final response = await get("/$url/page/$page", cancelToken: cancelToken);

    return await compute(
        _formatMzi, Three("${dio.options.baseUrl}/$url/", page, response.data));
  }

  static MziData _formatMzi(data) {
    final Three<String, int, dynamic> three = data;

    // 下面都在解析xml
    final document = parse(three.c);
    int maxPage = 0;
    // 获取最大页数
    document.getElementsByClassName("page-numbers").forEach((element) {
      try {
        final page = int.parse(element.text);
        if (page > maxPage) {
          maxPage = page;
        }
      } on FormatException catch (_) {}
    });
    final total = document.getElementsByClassName("postlist").first;
    final items = total.querySelectorAll("li");

    final list = List<MziItem>();
    items.forEach((item) {
      final img = item.querySelector("img");
      if (img == null) return;

      final imgUrl = img.attributes["data-original"];
      final imgHeight = img.attributes["height"] != "auto" &&
              img.attributes["width"] != "auto"
          ? int.parse(img.attributes["height"])
          : 354;
      final imgWidth = img.attributes["width"] != "auto" &&
              img.attributes["height"] != "auto"
          ? int.parse(img.attributes["width"])
          : 236;
      final link = item.querySelector("a[href]").attributes["href"];

      list.add(MziItem(
          url: imgUrl,
          link: link,
          refer: three.a,
          height: imgHeight,
          width: imgWidth,
          isImages: true));
    });

    return MziData(three.b, maxPage, list);
  }

  /// 获取每个妹子图集的最大数量
  Future<int> getLength({@required String link}) async {
    final response = await get(link, cancelToken: cancelToken);

    return await compute(_formatLen, response.data);
  }

  static int _formatLen(data) {
    int maxLength = 0;
    final document = parse(data);
    final total = document.getElementsByClassName("pagenavi").first;
    final spans = total.querySelectorAll("span");
    spans.map((span) {
      try {
        return int.parse(span.text);
      } on FormatException catch (_) {
        return -1;
      }
    }).forEach((index) {
      if (index > maxLength) {
        maxLength = index;
      }
    });

    return maxLength;
  }

  /// 获取图集下的每一张图片
  Future<MziItem> getEachData(
      {@required String link, @required int index}) async {
    final response = await get("$link/$index", cancelToken: cancelToken);

    return await compute(_formatItem, Three(link, index, response.data));
  }

  static MziItem _formatItem(data) {
    final Three<String, int, dynamic> three = data;

    final document = parse(three.c);
    final total = document.getElementsByClassName("main-image").first;
    final img = total.querySelector("img");
    final url = img.attributes["src"];
    final width = double.parse(img.attributes["width"]).toInt();
    final height = double.parse(img.attributes["height"]).toInt();
    final refer = "${three.a}/";

    return MziItem(
        url: url, width: width, height: height, refer: refer, isImages: false);
  }
}
