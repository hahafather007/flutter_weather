import 'package:flutter_weather/commom_import.dart';
import 'package:dio/dio.dart';

abstract class Service {
  @protected
  final dio = Dio();
  @protected
  final cancelToken = CancelToken();

  Service() {
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
  }

  void dispose() {
    cancelToken.cancel("cancelled");
  }
}
