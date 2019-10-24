import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/model/data/version_data.dart';
import 'package:flutter_weather/model/service/service.dart';
import 'package:html/parser.dart';

class AppVersionService extends Service {
  Future<VersionData> getVersion() async {
    final response =
        await dio.get("https://www.pgyer.com/Xcnf", cancelToken: cancelToken);

    final htmlStr = response.data.toString();
    final subStr = htmlStr.substring(
        htmlStr.indexOf("aKey = ") + 8, htmlStr.indexOf("agKey ="));
    final url = subStr.substring(0, subStr.indexOf("',"));
    debugPrint("url:$url");

    final document = parse(response.data);
    final elements = document.getElementsByClassName("span12 gray-text");
    final ul = elements.first.getElementsByClassName("breadcrumb").first;
    final lis = ul.children;
    final version = lis[0]
        .text
        .substring(lis[0].text.indexOf("build") + 6, lis[0].text.indexOf(")"));
    final size = lis[1].text.replaceFirst("大小：", "");
    final time = lis[2].text.substring(lis[2].text.indexOf("：") + 1);
    debugPrint("version:$version");
    debugPrint("size:$size");
    debugPrint("time:$time");

    return VersionData(
        version: int.parse(version),
        size: size,
        time: time,
        url: "https://www.pgyer.com/app/install/$url");
  }
}
