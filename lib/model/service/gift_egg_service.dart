import 'package:flutter_weather/commom_import.dart';

class GiftEggService extends Service {
  GiftEggService() {
    dio.options.baseUrl = "http://i.jandan.net";
  }

  Future<EggData> getData({@required int page}) async {
    final response =
        await dio.get("/?oxwlxojflwblxbsapi=jandan.get_ooxx_comments&page=$page");

    debugPrint(response.toString());

    final egg = EggData.fromJson(response.data);
    if(egg.status != "ok"){
      throw DioError(message: "我也不知为什么，它就是出错了");
    }else{
      return egg;
    }
  }
}
