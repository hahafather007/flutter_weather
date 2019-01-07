import 'package:flutter_weather/commom_import.dart';

class GiftMziImageService extends Service{
  /// 获取每个妹子图集的最大数量
  Future<int> getLength({@required String link}) async{
    final response = dio.get(link);

    return 0;
  }
}
