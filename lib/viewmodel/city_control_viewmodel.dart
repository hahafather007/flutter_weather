import 'package:flutter_weather/commom_import.dart';

class CityControlViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weathers = StreamController<List<Weather>>();

  List<String> _cacheCities = List();
  List<Weather> _cacheWeathers = List();

  CityControlViewModel() {
    _cacheCities.addAll(SharedDepository().cities);
    _cacheWeathers.addAll(SharedDepository().weathers);
    weathers.add(_cacheWeathers);
    cities.add(_cacheCities);
  }

  /// 添加城市
  Future<bool> addCity(String city) async {
    // 排除重复城市
    if (_cacheCities.contains(city)) return false;

    _cacheCities.add(city);
    final index = _cacheWeathers.length;
    _cacheWeathers.add(Weather());

    await SharedDepository().setCities(_cacheCities);
    await SharedDepository().setWeathers(_cacheWeathers);
    await SharedDepository()
        .setAirs(SharedDepository().airs..add(WeatherAir()));

    weathers.add(_cacheWeathers);
    cities.add(_cacheCities);

    final weatherData = await _loadWeather(city: city);
    if (weatherData?.weathers?.isNotEmpty ?? false) {
      _cacheWeathers.removeAt(index);
      _cacheWeathers.insert(index, weatherData.weathers.first);
      await SharedDepository().setWeathers(_cacheWeathers);
      weathers.add(_cacheWeathers);
    }

    return true;
  }

  /// 删除城市
  void removeCity(int index) async {
    _cacheCities.removeAt(index);
    _cacheWeathers.removeAt(index);
    await SharedDepository().setCities(_cacheCities);
    await SharedDepository().setWeathers(_cacheWeathers);
    await SharedDepository().setAirs(SharedDepository().airs..removeAt(index));

    weathers.add(_cacheWeathers);
    cities.add(_cacheCities);
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
    _cacheCities.clear();

    cities.close();
    weathers.close();

    super.dispose();
  }
}
