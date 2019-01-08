import 'package:flutter_weather/commom_import.dart';

class GiftMziService extends Service {
  GiftMziService() {
    dio.options.baseUrl = "http://www.mzitu.com";
  }

  Future<List<MziData>> getData(
      {@required String url, @required int page}) async {
    final response = await dio.get("/$url/page/$page");

    // 下面都在解析xml
    final document = parse(response.data);
    final total = document.getElementsByClassName("postlist").first;
    final items = total.querySelectorAll("li");

    final data = items.map((item) {
      final img = item.querySelector("img");
      final imgUrl = img.attributes["data-original"];
      final imgHeight = img.attributes["height"] != "auto"
          ? int.parse(img.attributes["height"])
          : 354;
      final imgWidth = img.attributes["width"] != "auto"
          ? int.parse(img.attributes["width"])
          : 236;
      final link = item.querySelector("a[href]").attributes["href"];
      final refer = "${dio.options.baseUrl}$url/";

      debugPrint("width===>$imgWidth  height ===>$imgHeight");
      debugPrint("=======>$imgUrl");
      debugPrint("=======>$link");
      debugPrint("=======>$refer");
      debugPrint("-------------------");

      return MziData(
          url: imgUrl,
          link: link,
          refer: refer,
          height: imgHeight,
          width: imgWidth);
    }).toList();

    return data;
  }
}
