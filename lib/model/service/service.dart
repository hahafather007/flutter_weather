import 'package:flutter_weather/commom_import.dart';

abstract class Service {
  final dio = Dio();
  final cancelToken = CancelToken();

  Service() {
    dio.options.connectTimeout = 5000;
  }

  void dispose() {
    cancelToken.cancel("cancelled");
  }
}
