import 'package:flutter_weather/commom_import.dart';

class CityControlViewModel extends ViewModel {
  final _service = WeatherService();

  final locations = StreamController<List<Location>>();
  final weathers = StreamController<List<Weather>>();

  List<Location> _cacheLocations = List();
  List<Weather> _cacheWeathers = List();

  CityControlViewModel() {
    _cacheLocations.addAll(SharedDepository().cities);
    _cacheWeathers.addAll(SharedDepository().weathers);
    weathers.add(_cacheWeathers);
    locations.add(_cacheLocations);
  }

  /// 添加城市
  void addCity(Location location) async {
    _cacheLocations.add(location);
    final index = _cacheWeathers.length;
    _cacheWeathers.add(Weather());

    await SharedDepository().setCities(_cacheLocations);
    await SharedDepository().setWeathers(_cacheWeathers);
    await SharedDepository()
        .setAirs(SharedDepository().airs..add(WeatherAir()));

    weathers.add(_cacheWeathers);
    locations.add(_cacheLocations);

    final weatherData = await _loadWeather(city: location.city);
    if (weatherData?.weathers?.isNotEmpty ?? false) {
      _cacheWeathers.removeAt(index);
      _cacheWeathers.insert(index, weatherData.weathers.first);
      await SharedDepository().setWeathers(_cacheWeathers);
      weathers.add(_cacheWeathers);
    }
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
    _cacheLocations.clear();

    locations.close();
    weathers.close();

    super.dispose();
  }
}
