import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

abstract class Service {
  @protected
  final dio = Dio();
  @protected
  final cancelToken = CancelToken();

  Service() {
    dio.options.connectTimeout = 8000;
    dio.options.receiveTimeout = 8000;
  }

  @protected
  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress}) async {
    final response = await retry(
        () => dio.get(path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress),
        maxAttempts: 3,
        retryIf: (e) => e is DioError && !CancelToken.isCancel(e));

    return response;
  }

  @protected
  Future<Response<T>> post<T>(String path,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress}) async {
    final response = await retry(
        () => dio.post(path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
        maxAttempts: 3,
        retryIf: (e) => e is DioError && !CancelToken.isCancel(e));

    return response;
  }

  @protected
  Future<Response<T>> delete<T>(String path,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken}) async {
    final response = await retry(
        () => dio.delete(path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken),
        maxAttempts: 3,
        retryIf: (e) => e is DioError && !CancelToken.isCancel(e));

    return response;
  }

  void dispose() {
    cancelToken.cancel("cancelled");
  }
}
