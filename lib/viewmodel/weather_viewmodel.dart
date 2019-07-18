import 'package:flutter_weather/commom_import.dart';

class WeatherViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weather = StreamController<Pair<Weather, AirNowCity>>();

  int _index = 0;
  Pair<Weather, AirNowCity> _catchWeather;

  WeatherViewModel() {
    bindSub(
        WeatherHolder().cityStream.listen((list) => streamAdd(cities, list)));
    bindSub(WeatherHolder()
        .cityStream
        .map((list) => min(_index, list.length - 1))
        .listen((index) {
      _catchWeather = Pair(WeatherHolder().weathers[index],
          WeatherHolder().airs[index]?.airNowCity);
      streamAdd(weather, _catchWeather);
    }));
  }

  void indexChange(int index) {
    _index = index;
    _catchWeather = Pair(WeatherHolder().weathers[index],
        WeatherHolder().airs[index]?.airNowCity);

    streamAdd(weather, _catchWeather);
  }

  /// 预览其他天气
  void switchType(String type) {
    _catchWeather?.a?.now?.condTxt = type;
    streamAdd(weather, _catchWeather);
  }

  @override
  void dispose() {
    _service.dispose();

    cities.close();
    weather.close();

    super.dispose();
  }
}
