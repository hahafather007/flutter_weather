import 'package:flutter_weather/commom_import.dart';

class GiftMziService extends Service {
  GiftMziService() {
    dio.options.baseUrl = "https://www.mzitu.com";
  }

  Future<List<MziData>> getData(
      {@required String url, @required int page}) async {
    final response = await dio.get("/$url/page/${page == 1 ? 0 : page}",
        cancelToken: cancelToken);

    // 下面都在解析xml
    final document = parse(response.data);
    final total = document.getElementsByClassName("postlist").first;
    final items = total.querySelectorAll("li");

    final data = List<MziData>();
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
      final refer = "${dio.options.baseUrl}$url/";

      data.add(MziData(
          url: imgUrl,
          link: link,
          refer: refer,
          height: imgHeight,
          width: imgWidth,
          isImages: true));
    });

    return data;
  }
}
