import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/city_data.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/holder/weather_holder.dart';
import 'package:flutter_weather/model/service/weather_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class CityControlViewModel extends ViewModel {
  final cities = StreamController<List<String>>();
  final weathers = StreamController<List<Weather>>();

  final _service = WeatherService();
  final List<String> _cacheCities = [];
  final List<Weather> _cacheWeathers = [];

  CityControlViewModel() {
    _cacheCities.addAll(WeatherHolder().cities.map((v) => v.name));
    _cacheWeathers.addAll(WeatherHolder().weathers);
    cities.safeAdd(_cacheCities);
    weathers.safeAdd(_cacheWeathers);
    WeatherHolder().weatherStream.listen((v) {
      _cacheWeathers.clear();
      _cacheWeathers.addAll(v);
      weathers.safeAdd(_cacheWeathers);
    }).bindLife(this);
    WeatherHolder()
        .cityStream
        .map((list) => list.map((v) => v.name).toList())
        .listen((v) {
      _cacheCities.clear();
      _cacheCities.addAll(v);
      cities.safeAdd(_cacheCities);
    }).bindLife(this);
  }

  /// 添加城市
  Future<bool> addCity(District city) async {
    // 排除重复城市
    if (WeatherHolder().cities.contains(city)) return false;

    final index = WeatherHolder().weathers.length;
    await WeatherHolder().addWeather(Weather());
    await WeatherHolder().addAir(WeatherAir());
    await WeatherHolder().addCity(city);

    final weatherData = await _loadWeather(city: city);
    if (weatherData?.weathers?.isNotEmpty ?? false) {
      await WeatherHolder()
          .addWeather(weatherData.weathers.first, updateIndex: index);
    }

    return true;
  }

  /// 删除城市
  void removeCity(int index) async {
    await WeatherHolder().removeWeather(index);
    await WeatherHolder().removeAir(index);
    await WeatherHolder().removeCity(index);
  }

  void cityIndexChange(int before, int after) async {
    if (before == 0 || after == 0) return;

    final beforeCity = _cacheCities[before];
    _cacheCities.removeAt(before);
    _cacheCities.insert(after, beforeCity);
    final beforeWeather = _cacheWeathers[before];
    _cacheWeathers.removeAt(before);
    _cacheWeathers.insert(after, beforeWeather);
    cities.safeAdd(_cacheCities);
    weathers.safeAdd(_cacheWeathers);

    await WeatherHolder().updateAir(before, after);
    await WeatherHolder().updateWeather(before, after);
    await WeatherHolder().updateCity(before, after);
  }

  /// 获取天气
  Future<WeatherData> _loadWeather({@required District city}) async {
    try {
      final data = await _service.getWeather(city: city.id);

      return data;
    } on DioError catch (e) {
      doError(e);
    }

    return null;
  }

  @override
  void dispose() {
    _service.dispose();

    cities.close();
    weathers.close();
    _cacheCities.clear();
    _cacheWeathers.clear();

    super.dispose();
  }
}
