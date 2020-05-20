import 'dart:async';
import 'dart:math';

import 'package:flutter_weather/model/data/mixing.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/holder/weather_holder.dart';
import 'package:flutter_weather/model/service/weather_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class WeatherViewModel extends ViewModel {
  final cities = StreamController<List<String>>();
  final weather = StreamController<Pair<Weather, AirNowCity>>();
  final hideWeather = StreamController<bool>();

  final _service = WeatherService();

  int _index = 0;
  Pair<Weather, AirNowCity> _catchWeather;

  WeatherViewModel() {
    WeatherHolder().cityStream.listen((list) {
      cities.safeAdd(list.map((v) => v.name).toList());

      final index = min(_index, list.length - 1);
      _catchWeather = Pair(WeatherHolder().weathers[index],
          WeatherHolder().airs[index]?.airNowCity);
      weather.safeAdd(_catchWeather);
    }).bindLife(this);

    final index = min(_index, WeatherHolder().cities.length - 1);
    _catchWeather = Pair(WeatherHolder().weathers[index],
        WeatherHolder().airs[index]?.airNowCity);
    weather.safeAdd(_catchWeather);
    cities.safeAdd(WeatherHolder().cities.map((v) => v.name).toList());
  }

  void indexChange(int index) {
    _index = index;
    _catchWeather = Pair(WeatherHolder().weathers[index],
        WeatherHolder().airs[index]?.airNowCity);

    weather.safeAdd(_catchWeather);
  }

  /// 预览其他天气
  void switchType(String type) {
    _catchWeather?.a?.now?.condTxt = type;
    weather.safeAdd(_catchWeather);
  }

  void changeHideState(bool hide) {
    hideWeather.safeAdd(hide);
  }

  @override
  void dispose() {
    _service.dispose();

    hideWeather.close();
    cities.close();
    weather.close();

    super.dispose();
  }
}
