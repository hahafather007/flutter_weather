import 'package:flutter_weather/commom_import.dart';

class WeatherViewModel extends ViewModel {
  final _service = WeatherService();

  final cities = StreamController<List<String>>();
  final weatherType = StreamController<String>();

  int _index = 0;

  WeatherViewModel() {
    bindSub(
        WeatherHolder().cityStream.listen((list) => streamAdd(cities, list)));
    bindSub(WeatherHolder()
        .weatherStream
        .map((list) => list[min(_index, list.length - 1)])
        .listen((v) => streamAdd(weatherType, v.now?.condTxt)));
  }

  void indexChange(int index) {
    _index = index;

    streamAdd(weatherType, WeatherHolder().weathers[index].now?.condTxt);
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
