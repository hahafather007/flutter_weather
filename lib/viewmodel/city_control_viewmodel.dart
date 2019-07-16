import 'package:flutter_weather/commom_import.dart';
import 'package:dio/dio.dart';

class CityControlViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weathers = StreamController<List<Weather>>();

  CityControlViewModel() {
    streamAdd(cities, WeatherHolder().cities);
    streamAdd(weathers, WeatherHolder().weathers);
    bindSub(
        WeatherHolder().weatherStream.listen((v) => streamAdd(weathers, v)));
    bindSub(WeatherHolder().cityStream.listen((v) => streamAdd(cities, v)));
  }

  /// 添加城市
  Future<bool> addCity(String city) async {
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

    await WeatherHolder().updateWeather(before, after);
    await WeatherHolder().updateAir(before, after);
    await WeatherHolder().updateCity(before, after);
  }

  /// 获取天气
  Future<WeatherData> _loadWeather({@required String city}) async {
    try {
      final data = await _service.getWeather(city: city);

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

    super.dispose();
  }
}
