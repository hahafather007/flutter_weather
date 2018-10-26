import 'package:flutter_weather/commom_import.dart';

class WeatherPresenter extends Presenter {
  final _service = WeatherService();

  WeatherInter _inter;

  bool isLoading = false;
  String city = "";
  Weather weather;

  WeatherPresenter(this._inter) {
    city = SharedDepository().lastCity;
  }

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
    if (isLoading) return;

    isLoading = true;
    _inter.stateChange();

    try {
      city = await getLocation();
      if (city == null) {
        city = SharedDepository().lastCity;
      } else {
        SharedDepository().setLastCity(city);
      }

      final data = await _service.getWeather(city: city);

      weather = data.weathers.firstWhere((v) => v != null && v.basic != null);
    } on DioError catch (e) {
      doError(e);
    } finally {
      isLoading = false;
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
