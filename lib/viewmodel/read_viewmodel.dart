import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/service/read_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class ReadViewModel extends ViewModel {
  final titles = StreamController<List<ReadTitle>>();

  final _service = ReadService();

  Future<void> loadTitle() async {
    if (selfLoading) return;

    selfLoading = true;
    isLoading.safeAdd(true);

    try {
      titles.safeAdd(await _service.getTitles());
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.safeAdd(false);
    }
  }

  @override
  void dispose() {
    _service.dispose();

    titles.close();

    super.dispose();
  }
}
