import 'package:flutter_weather/commom_import.dart';

class WeatherPresenter extends Presenter {
  final _service = WeatherService();

  WeatherInter _inter;

  bool isLoading = false;
  bool isRefresh = false;
  String city = "";
  Weather weather;
  WeatherAir air;

  WeatherPresenter(this._inter) {
    city = SharedDepository().lastCity;
  }

  Future<Null> loadData() async {
    final minutes = (DateTime.now().millisecondsSinceEpoch -
            DateTime.parse(SharedDepository().weatherUpdateTime)
                .millisecondsSinceEpoch) /
        (1000 * 60);
    debugPrint("-========$minutes");

    // 两次请求时间间隔需要大于5分钟
    // 如果小于5分钟，就返回保存的数据
    if (minutes >= 5) {
      await refresh(refresh: false);
    } else {
      final json = JsonCodec();

      weather =
          WeatherData.fromJson(json.decode(SharedDepository().lastWeatherData))
              .weathers
              .first;
      air = WeatherAirData.fromJson(json.decode(SharedDepository().lastAirData))
          .weatherAir
          .first;

      _inter.stateChange();
    }
  }

  Future<Null> refresh({bool refresh = true}) async {
    if (isLoading || isRefresh) return;

    if (refresh) {
      refresh = true;
    } else {
      isLoading = true;
    }
    _inter.stateChange();

    try {
      city = await getLocation();
      if (city == null) {
        city = SharedDepository().lastCity;
      } else {
        SharedDepository().setLastCity(city);
      }

      final weatherData = await _service.getWeather(city: city);
      final airData = await _service.getAir(city: city);
      await SharedDepository().setWeatherUpdateTime(DateTime.now().toString());

      weather = weatherData.weathers.first;
      air = airData.weatherAir.first;
    } on DioError catch (e) {
      doError(e);
    } finally {
      isLoading = false;
      isRefresh = false;
      _inter.stateChange();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _inter = null;
    _service.dispose();
  }
}
