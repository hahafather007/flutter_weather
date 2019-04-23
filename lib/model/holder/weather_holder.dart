import 'package:flutter_weather/commom_import.dart';

class WeatherHolder {
  static final WeatherHolder _holder = WeatherHolder._internal();

  factory WeatherHolder() => _holder;

  final _citiesBroadcast = StreamController<List<String>>();
  final _weathersBroadcast = StreamController<List<Weather>>();
  final _airsBroadcast = StreamController<List<WeatherAir>>();

  Stream<List<String>> cityStream;
  Stream<List<Weather>> weatherStream;
  Stream<List<WeatherAir>> airStream;
  List<String> _cacheCities;
  List<Weather> _cacheWeathers;
  List<WeatherAir> _cacheAirs;

  WeatherHolder._internal() {
    cityStream = _citiesBroadcast.stream.asBroadcastStream();
    weatherStream = _weathersBroadcast.stream.asBroadcastStream();
    airStream = _airsBroadcast.stream.asBroadcastStream();

    _cacheCities = SharedDepository().cities;
    _cacheWeathers = SharedDepository().weathers;
    _cacheAirs = SharedDepository().airs;

    streamAdd(_citiesBroadcast, _cacheCities);
    streamAdd(_weathersBroadcast, _cacheWeathers);
    streamAdd(_airsBroadcast, _cacheAirs);
  }

  List<String> get cities => _cacheCities;

  Future<Null> addCity(String city, {int updateIndex}) async {
    if (updateIndex == null) {
      _cacheCities.add(city);
    } else {
      _cacheCities.removeAt(updateIndex);
      _cacheCities.insert(updateIndex, city);
    }
    await SharedDepository().setCities(_cacheCities);
    streamAdd(_citiesBroadcast, _cacheCities);
  }

  Future<Null> updateCity(int before, int after) async {
    final mCity = _cacheCities[before];
    _cacheCities.removeAt(before);
    _cacheCities.insert(after, mCity);
    await SharedDepository().setCities(_cacheCities);
    streamAdd(_citiesBroadcast, _cacheCities);
  }

  Future<Null> removeCity(int index) async {
    _cacheCities.removeAt(index);
    await SharedDepository().setCities(_cacheCities);
    streamAdd(_citiesBroadcast, _cacheCities);
  }

  List<Weather> get weathers => _cacheWeathers;

  Future<Null> addWeather(Weather weather, {int updateIndex}) async {
    if (updateIndex == null) {
      _cacheWeathers.add(weather);
    } else {
      _cacheWeathers.removeAt(updateIndex);
      _cacheWeathers.insert(updateIndex, weather);
    }
    await SharedDepository().setWeathers(_cacheWeathers);
    streamAdd(_weathersBroadcast, _cacheWeathers);
  }

  Future<Null> updateWeather(int before, int after) async {
    final mWeather = _cacheWeathers[before];
    _cacheWeathers.removeAt(before);
    _cacheWeathers.insert(after, mWeather);
    await SharedDepository().setWeathers(_cacheWeathers);
    streamAdd(_weathersBroadcast, _cacheWeathers);
  }

  Future<Null> removeWeather(int index) async {
    _cacheWeathers.removeAt(index);
    await SharedDepository().setWeathers(_cacheWeathers);
    streamAdd(_weathersBroadcast, _cacheWeathers);
  }

  List<WeatherAir> get airs => _cacheAirs;

  Future<Null> addAir(WeatherAir air, {int updateIndex}) async {
    if (updateIndex == null) {
      _cacheAirs.add(air);
    } else {
      _cacheAirs.removeAt(updateIndex);
      _cacheAirs.insert(updateIndex, air);
    }
    await SharedDepository().setAirs(_cacheAirs);
    streamAdd(_airsBroadcast, _cacheAirs);
  }

  Future<Null> updateAir(int before, int after) async {
    final mAir = _cacheAirs[before];
    _cacheAirs.removeAt(before);
    _cacheAirs.insert(after, mAir);
    await SharedDepository().setAirs(_cacheAirs);
    streamAdd(_airsBroadcast, _cacheAirs);
  }

  Future<Null> removeAir(int index) async {
    _cacheAirs.removeAt(index);
    await SharedDepository().setAirs(_cacheAirs);
    streamAdd(_airsBroadcast, _cacheAirs);
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
