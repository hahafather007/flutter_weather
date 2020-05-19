import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_weather/model/data/gank_data.dart';
import 'package:flutter_weather/model/service/gank_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class ReadViewModel extends ViewModel {
  final titles = StreamController<List<GankTitle>>();

  final _service = GankService();

  Future<void> loadTitle() async {
    if (selfLoading) return;

    selfLoading = true;
    isLoading.safeAdd(true);

    try {
      titles.safeAdd(await _service.getTitles(category: "Article"));
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.safeAdd(false);
    }
  }

  @override
  void reload() {
    super.reload();

    loadTitle();
  }

  @override
  void dispose() {
    _service.dispose();

    titles.close();

    super.dispose();
  }
}
