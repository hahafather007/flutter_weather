import 'package:flutter_weather/commom_import.dart';
import 'package:dio/dio.dart';

class CityControlViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weathers = StreamController<List<Weather>>();

  List<String> _cacheCities = [];
  List<Weather> _cacheWeathers = [];

  CityControlViewModel() {
    _cacheCities.addAll(WeatherHolder().cities.map((v) => v.name));
    _cacheWeathers.addAll(WeatherHolder().weathers);
    streamAdd(cities, _cacheCities);
    streamAdd(weathers, _cacheWeathers);
    bindSub(WeatherHolder().weatherStream.listen((v) {
      _cacheWeathers.clear();
      _cacheWeathers.addAll(v);
      streamAdd(weathers, _cacheWeathers);
    }));
    bindSub(WeatherHolder()
        .cityStream
        .map((list) => list.map((v) => v.name).toList())
        .listen((v) {
      _cacheCities.clear();
      _cacheCities.addAll(v);
      streamAdd(cities, _cacheCities);
    }));
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
    streamAdd(cities, _cacheCities);
    streamAdd(weathers, _cacheWeathers);

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
