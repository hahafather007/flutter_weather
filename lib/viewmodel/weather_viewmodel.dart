import 'dart:async';
import 'dart:math';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/mixing.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/holder/weather_holder.dart';
import 'package:flutter_weather/model/service/weather_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class WeatherViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weather = StreamController<Pair<Weather, AirNowCity>>();
  final hideWeather = StreamController<bool>();

  int _index = 0;
  Pair<Weather, AirNowCity> _catchWeather;

  WeatherViewModel() {
    bindSub(WeatherHolder()
        .cityStream
        .map((list) => list.map((v) => v.name).toList())
        .listen((list) => streamAdd(cities, list)));
    bindSub(WeatherHolder()
        .cityStream
        .map((list) => min(_index, list.length - 1))
        .listen((index) {
      _catchWeather = Pair(WeatherHolder().weathers[index],
          WeatherHolder().airs[index]?.airNowCity);
      streamAdd(weather, _catchWeather);
    }));
  }

  void indexChange(int index) {
    _index = index;
    _catchWeather = Pair(WeatherHolder().weathers[index],
        WeatherHolder().airs[index]?.airNowCity);

    streamAdd(weather, _catchWeather);
  }

  /// 预览其他天气
  void switchType(String type) {
    _catchWeather?.a?.now?.condTxt = type;
    streamAdd(weather, _catchWeather);
  }

  void changeHideState(bool hide) {
    streamAdd(hideWeather, hide);
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
