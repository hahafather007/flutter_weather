import 'package:flutter_weather/commom_import.dart';

class ReadService extends Service {
  ReadService() {
    dio.options.baseUrl = "http://gank.io";
  }

  Future<Null> getClassification() async {
    final response = await dio.get("/xiandu");

    // 解析xml
    final document = parse(response.data);
    final cate = document.getElementById("xiandu_cat");
    final links = cate.querySelectorAll("a[href]");

    links.forEach((link) {
      final name = link.text;
      final url = link.attributes["href"];

      debugPrint("name=======>$name");
      debugPrint("url=======>$url");
    });
  }
}
