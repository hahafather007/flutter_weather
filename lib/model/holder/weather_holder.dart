import 'dart:async';

import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/city_data.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';

class WeatherHolder {
  static final WeatherHolder _holder = WeatherHolder._internal();

  factory WeatherHolder() => _holder;

  final _citiesBroadcast = StreamController<List<District>>();
  final _weathersBroadcast = StreamController<List<Weather>>();
  final _airsBroadcast = StreamController<List<WeatherAir>>();

  Stream<List<District>> cityStream;
  Stream<List<Weather>> weatherStream;
  Stream<List<WeatherAir>> airStream;
  List<District> _cacheCities;
  List<Weather> _cacheWeathers;
  List<WeatherAir> _cacheAirs;

  List<District> get cities => _cacheCities;

  List<Weather> get weathers => _cacheWeathers;

  List<WeatherAir> get airs => _cacheAirs;

  WeatherHolder._internal() {
    cityStream = _citiesBroadcast.stream.asBroadcastStream();
    weatherStream = _weathersBroadcast.stream.asBroadcastStream();
    airStream = _airsBroadcast.stream.asBroadcastStream();

    _cacheCities = SharedDepository().districts;
    _cacheWeathers = SharedDepository().weathers;
    _cacheAirs = SharedDepository().airs;

    _citiesBroadcast.safeAdd(_cacheCities);
    _weathersBroadcast.safeAdd(_cacheWeathers);
    _airsBroadcast.safeAdd(_cacheAirs);
  }

  Future<Null> addCity(District city, {int updateIndex}) async {
    if (updateIndex == null) {
      _cacheCities.add(city);
    } else {
      _cacheCities.removeAt(updateIndex);
      _cacheCities.insert(updateIndex, city);
    }
    await SharedDepository().setDistricts(_cacheCities);
    _citiesBroadcast.safeAdd(_cacheCities);
  }

  Future<Null> updateCity(int before, int after) async {
    final mCity = _cacheCities[before];
    _cacheCities.removeAt(before);
    _cacheCities.insert(after, mCity);
    await SharedDepository().setDistricts(_cacheCities);
    _citiesBroadcast.safeAdd(_cacheCities);
  }

  Future<Null> removeCity(int index) async {
    _cacheCities.removeAt(index);
    await SharedDepository().setDistricts(_cacheCities);
    _citiesBroadcast.safeAdd(_cacheCities);
  }

  Future<Null> addWeather(Weather weather, {int updateIndex}) async {
    if (updateIndex == null) {
      _cacheWeathers.add(weather);
    } else {
      _cacheWeathers.removeAt(updateIndex);
      _cacheWeathers.insert(updateIndex, weather);
    }
    await SharedDepository().setWeathers(_cacheWeathers);
    _weathersBroadcast.safeAdd(_cacheWeathers);
  }

  Future<Null> updateWeather(int before, int after) async {
    final mWeather = _cacheWeathers[before];
    _cacheWeathers.removeAt(before);
    _cacheWeathers.insert(after, mWeather);
    await SharedDepository().setWeathers(_cacheWeathers);
    _weathersBroadcast.safeAdd(_cacheWeathers);
  }

  Future<Null> removeWeather(int index) async {
    _cacheWeathers.removeAt(index);
    await SharedDepository().setWeathers(_cacheWeathers);
    _weathersBroadcast.safeAdd(_cacheWeathers);
  }

  Future<Null> addAir(WeatherAir air, {int updateIndex}) async {
    if (updateIndex == null) {
      _cacheAirs.add(air);
    } else {
      _cacheAirs.removeAt(updateIndex);
      _cacheAirs.insert(updateIndex, air);
    }
    await SharedDepository().setAirs(_cacheAirs);
    _airsBroadcast.safeAdd(_cacheAirs);
  }

  Future<Null> updateAir(int before, int after) async {
    final mAir = _cacheAirs[before];
    _cacheAirs.removeAt(before);
    _cacheAirs.insert(after, mAir);
    await SharedDepository().setAirs(_cacheAirs);
    _airsBroadcast.safeAdd(_cacheAirs);
  }

  Future<Null> removeAir(int index) async {
    _cacheAirs.removeAt(index);
    await SharedDepository().setAirs(_cacheAirs);
    _airsBroadcast.safeAdd(_cacheAirs);
  }

  void dispose() {
    _citiesBroadcast.close();
    _weathersBroadcast.close();
    _airsBroadcast.close();

    _cacheCities?.clear();
    _cacheAirs?.clear();
    _cacheWeathers?.clear();
  }
}
