import 'package:flutter_weather/commom_import.dart';

class WeatherHolder {
  static final WeatherHolder _holder = WeatherHolder._internal();

  factory WeatherHolder() => _holder;

  final _citiesBroadcast = StreamController<List<String>>();
  final _weathersBroadcast = StreamController<List<Weather>>();
  final _airsBroadcast = StreamController<List<WeatherAir>>();

  Stream<List<String>> cities;
  Stream<List<Weather>> weathers;
  Stream<List<WeatherAir>> airs;
  List<String> _cacheCities;
  List<Weather> _cacheWeathers;
  List<WeatherAir> _cacheAirs;

  WeatherHolder._internal() {
    cities = _citiesBroadcast.stream.asBroadcastStream();
    weathers = _weathersBroadcast.stream.asBroadcastStream();
    airs = _airsBroadcast.stream.asBroadcastStream();

    _cacheCities = SharedDepository().cities;
    _cacheWeathers = SharedDepository().weathers;
    _cacheAirs = SharedDepository().airs;

    streamAdd(_citiesBroadcast, _cacheCities);
    streamAdd(_weathersBroadcast, _cacheWeathers);
    streamAdd(_airsBroadcast, _cacheAirs);
  }

  Future<Null> setCities(List<String> cities) async{
    _cacheCities = cities;
    await SharedDepository().setCities(cities);
    streamAdd(_citiesBroadcast, _cacheCities);
  }

  Future<Null> setWeathers(List<Weather> weathers) async{
    _cacheWeathers = weathers;
    await SharedDepository().setWeathers(weathers);
    streamAdd(_weathersBroadcast, _cacheWeathers);
  }

  Future<Null> setAirs(List<WeatherAir> airs) async{
    _cacheAirs = airs;
    await SharedDepository().setAirs(airs);
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
