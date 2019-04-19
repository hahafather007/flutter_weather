import 'package:flutter_weather/commom_import.dart';

class WeatherViewModel extends ViewModel {
  final _service = WeatherService();

  final city = StreamController<String>();
  final weather = StreamController<Weather>();
  final air = StreamController<WeatherAir>();
  final weatherType = StreamController<String>();

  WeatherViewModel() {
    streamAdd(city, SharedDepository().cities.first.district);

    // 首先将缓存的数据作为第一数据显示，再判断请求逻辑
    final mWeather = SharedDepository().weathers.first;
    final mAir = SharedDepository().airs.first;
    streamAdd(weather, mWeather);
    streamAdd(weatherType, mWeather.now?.condTxt);
    streamAdd(air, mAir);

    loadData(isRefresh: false);
  }

  Future<Null> loadData({bool isRefresh = true}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (!isRefresh) {
      streamAdd(isLoading, true);
    }

    // 请求定位权限
    await SimplePermissions.requestPermission(Permission.AlwaysLocation);

    try {
      final cities = SharedDepository().cities;
      final location = await ChannelUtil.getLocation() ?? cities.first;
      cities.removeAt(0);
      cities.insert(0, location);
      streamAdd(city, location.district);

      final weatherData = await _service.getWeather(city: location.district);
      final airData = await _service.getAir(city: location.city);
      // 储存本次天气结果
      if (weatherData?.weathers?.isNotEmpty ?? false) {
        streamAdd(weather, weatherData.weathers.first);
        streamAdd(weatherType, weatherData.weathers.first.now.condTxt);

        final weathers = SharedDepository().weathers;
        weathers.removeAt(0);
        weathers.insert(0, weatherData.weathers.first);
        await SharedDepository().setWeathers(weathers);
      }
      if (airData?.weatherAir?.isNotEmpty ?? false) {
        streamAdd(air, airData.weatherAir.first);

        final airs = SharedDepository().airs;
        airs.removeAt(0);
        airs.insert(0, airData.weatherAir.first);
        await SharedDepository().setAirs(airs);
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

  /// 预览其他天气
  void switchType(String type) => streamAdd(weatherType, type);

  @override
  void dispose() {
    _service.dispose();

    city.close();
    weather.close();
    air.close();
    weatherType.close();

    super.dispose();
  }
}
