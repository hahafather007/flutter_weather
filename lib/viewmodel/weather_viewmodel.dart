import 'package:flutter_weather/commom_import.dart';

class WeatherViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weatherType = StreamController<String>();

  int _index = 0;

  WeatherViewModel() {
    WeatherHolder().cities.listen((list) => streamAdd(cities, list));
    WeatherHolder().weathers
      ..map((list) => list[_index])
          .listen((v) => streamAdd(weatherType, v.now?.condTxt));
  }

  void indexChange(int index) {
    _index = index;
  }

  /// 预览其他天气
  void switchType(String type) => streamAdd(weatherType, type);

  @override
  void dispose() {
    _service.dispose();

    cities.close();
    weatherType.close();

    super.dispose();
  }
}
