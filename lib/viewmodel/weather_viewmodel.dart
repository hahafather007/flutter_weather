import 'package:flutter_weather/commom_import.dart';

class WeatherViewModel extends ViewModel {
  final _service = WeatherService();

  final city = StreamController<String>();
  final weather = StreamController<Weather>();
  final air = StreamController<WeatherAir>();
  final weatherType = StreamController<String>();

  void init() {
    streamAdd(city, SharedDepository().lastCity.split(",")[0]);

    // 首先将缓存的数据作为第一数据显示，再判断请求逻辑
    final lastWeatherData = SharedDepository().lastWeatherData;
    final lastAirData = SharedDepository().lastAirData;
    if (lastAirData != null && lastWeatherData != null) {
      final mWeather =
          WeatherData.fromJson(json.decode(lastWeatherData)).weathers.first;
      final mAir =
          WeatherAirData.fromJson(json.decode(lastAirData)).weatherAir.first;

      streamAdd(weather, mWeather);
      streamAdd(weatherType, mWeather.now?.condTxt);
      streamAdd(air, mAir);
    }

    final minutes = (DateTime.now().millisecondsSinceEpoch -
            DateTime.parse(SharedDepository().weatherUpdateTime)
                .millisecondsSinceEpoch) ~/
        1000;
    debugPrint("时间========$minutes秒");
    // 两次请求时间间隔需要大于5分钟（300秒）
    if (minutes >= 300) {
      loadData(isRefresh: false);
    }
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
      var mCity =
          (await ChannelUtil.getLocation() ?? SharedDepository().lastCity)
              .split(",");
      SharedDepository().setLastCity("${mCity[0]},${mCity[1]}");
      streamAdd(city, mCity[0]);

      final weatherData = await _service.getWeather(city: mCity[0]);
      final airData = await _service.getAir(city: mCity[1]);
      // 储存本次天气结果
      await SharedDepository().setWeatherUpdateTime(DateTime.now().toString());
      await SharedDepository().setLastWeatherData(json.encode(weatherData));
      await SharedDepository().setLastAirData(json.encode(airData));

      streamAdd(weather, weatherData.weathers.first);
      streamAdd(weatherType, weatherData.weathers.first.now.condTxt);
      streamAdd(air, airData.weatherAir.first);
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
