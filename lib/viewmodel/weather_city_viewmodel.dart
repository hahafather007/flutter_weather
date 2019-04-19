import 'package:flutter_weather/commom_import.dart';

class WeatherCityViewModel extends ViewModel {
  final _service = WeatherService();

  final weather = StreamController<Weather>();
  final air = StreamController<WeatherAir>();

  WeatherCityViewModel() {
    // 首先将缓存的数据作为第一数据显示，再判断请求逻辑
    final mWeather = SharedDepository().weathers.first;
    final mAir = SharedDepository().airs.first;
    streamAdd(weather, mWeather);
    streamAdd(air, mAir);
  }

  Future<Null> loadData(int index, {bool isRefresh = true}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (!isRefresh) {
      streamAdd(isLoading, true);
    }

    final cities = SharedDepository().cities;
    String mCity;
    if (index == 0) {
      // 请求定位权限
      await SimplePermissions.requestPermission(Permission.AlwaysLocation);

      mCity = await ChannelUtil.getLocation() ?? cities.first;
      cities.removeAt(0);
      cities.insert(0, mCity);
      WeatherHolder().setCities(cities);
    } else {
      mCity = cities[index];
    }

    try {
      final weatherData = await _service.getWeather(city: mCity);
      // 储存本次天气结果
      if (weatherData?.weathers?.isNotEmpty ?? false) {
        final mWeather = weatherData.weathers.first;
        streamAdd(weather, mWeather);

        final weathers = SharedDepository().weathers;
        weathers.removeAt(0);
        weathers.insert(0, weatherData.weathers.first);

        final airData = await _service.getAir(city: mWeather.basic.parentCity);
        if (airData?.weatherAir?.isNotEmpty ?? false) {
          streamAdd(air, airData.weatherAir.first);

          final airs = SharedDepository().airs;
          airs.removeAt(0);
          airs.insert(0, airData.weatherAir.first);
        }
      }
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;

      if (!isRefresh) {
        streamAdd(isLoading, false);
      }
    }
  }

  @override
  void dispose() {
    _service.dispose();

    weather.close();
    air.close();

    super.dispose();
  }
}
