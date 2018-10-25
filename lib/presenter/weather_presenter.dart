import 'package:flutter_weather/commom_import.dart';

class WeatherPresenter extends Presenter {
  WeatherInter inter;
  bool isLoading = false;
  String city = "";

  WeatherPresenter(this.inter) {
    city = SharedDepository().lastCity;
  }

  void loadData() {
    refresh();
  }

  Future<Null> refresh() async {
    city = await getLocation();
    SharedDepository().setLastCity(city);

    inter.stateChange();
  }

  @override
  void dispose() {
    super.dispose();

    inter = null;
  }
}
