import 'package:flutter_weather/commom_import.dart';

class AppVersionService extends Service {
  AppVersionService() {
    dio.options.baseUrl = "https://raw.githubusercontent.com";
  }

  Future<VersionData> getVersion() async {
    final response = await dio.get(
        "/hahafather007/flutter_weather/master/version",
        cancelToken: cancelToken);

    debugPrint(response.toString());

    return VersionData.fromJson(jsonDecode(response.data));
  }
}
