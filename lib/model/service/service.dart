import 'package:flutter_weather/commom_import.dart';

abstract class Service {
  @protected
  final dio = Dio();
  @protected
  final cancelToken = CancelToken();

  Service() {
    dio.options.connectTimeout = 5000;
  }

  void dispose() {
    cancelToken.cancel("cancelled");
  }
}
