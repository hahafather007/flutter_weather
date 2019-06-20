import 'package:flutter_weather/commom_import.dart';

class WeatherViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weather = StreamController<Pair<Weather, AirNowCity>>();

  int _index = 0;

  WeatherViewModel() {
    bindSub(
        WeatherHolder().cityStream.listen((list) => streamAdd(cities, list)));
    bindSub(WeatherHolder()
        .cityStream
        .map((list) => min(_index, list.length - 1))
        .listen((index) => streamAdd(
            weather,
            Pair(WeatherHolder().weathers[index],
                WeatherHolder().airs[index]?.airNowCity))));
  }

  void indexChange(int index) {
    _index = index;

    streamAdd(
        weather,
        Pair(WeatherHolder().weathers[index],
            WeatherHolder().airs[index]?.airNowCity));
  }

  /// 预览其他天气
  void switchType(String type) => streamAdd(weather, type);

  @override
  void dispose() {
    _service.dispose();

    cities.close();
    weather.close();

    super.dispose();
  }
}
