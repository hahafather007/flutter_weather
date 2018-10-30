import 'package:flutter_weather/commom_import.dart';

class GiftMziService extends Service {
  GiftMziService() {
    dio.options.baseUrl = "http://www.mzitu.com";
  }

  Future<List<MziData>> getData(
      {@required String url, @required int page}) async {
    final response = await dio.get("$url/page/$page");

    // 下面都在解析xml
    final document = parse(response.data);
    final total = document.getElementsByClassName("postlist").first;
    final items = total.querySelectorAll("li");

    final datas = items.map((item) {
      final imgUrl = item.querySelector("img").attributes["data-original"];
      final link = item.querySelector("a[href]").attributes["href"];
      final refer = "$url/";

      debugPrint("=======>$imgUrl");
      debugPrint("=======>$link");
      debugPrint("=======>$refer");
      debugPrint("-------------------");

      return MziData(url: imgUrl, link: link, refer: refer);
    }).toList();

    return datas;
  }
}
