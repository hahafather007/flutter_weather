import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/city_data.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/holder/weather_holder.dart';
import 'package:flutter_weather/model/service/weather_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class WeatherCityViewModel extends ViewModel {
  final int index;

  final _service = WeatherService();

  final weather = StreamController<Weather>();
  final air = StreamController<WeatherAir>();

  WeatherCityViewModel({@required this.index}) {
    // 首先将缓存的数据作为第一数据显示，再判断请求逻辑
    final mWeather = WeatherHolder().weathers[index];
    final mAir = WeatherHolder().airs[index];
    streamAdd(weather, mWeather);
    streamAdd(air, mAir);

    loadData(isRefresh: false);
  }

  Future<Null> loadData({bool isRefresh = true}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (!isRefresh) {
      streamAdd(isLoading, true);
    }

    District mCity;
    if (index == 0) {
      mCity = District(name: "成都", id: "CN101270101");
    } else {
      mCity = WeatherHolder().cities[index];
    }

    try {
      final weatherData = await _service.getWeather(city: mCity.id);
      // 储存本次天气结果
      if (weatherData?.weathers?.isNotEmpty ?? false) {
        final mWeather = weatherData.weathers.first;
        streamAdd(weather, mWeather);

        final airData = await _service.getAir(city: mWeather.basic?.parentCity);
        if (airData?.weatherAir?.isNotEmpty ?? false) {
          final mAir = airData.weatherAir.first;
          streamAdd(air, mAir);

          WeatherHolder().addCity(mCity, updateIndex: index);
          WeatherHolder().addWeather(mWeather, updateIndex: index);
          WeatherHolder().addAir(mAir, updateIndex: index);
        }
      }
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;

      if (!isRefresh) {
        streamAdd(isLoading, false);
      }
    }
  }

  @override
  void dispose() {
    _service.dispose();

    weather.close();
    air.close();

    super.dispose();
  }
}
