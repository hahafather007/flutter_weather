import 'package:flutter_weather/commom_import.dart';

class WeatherService extends Service {
  WeatherService() {
    dio.options.baseUrl = "https://free-api.heweather.com";
  }

  Future<WeatherData> getWeather({@required String city}) async {
    final response =
        await dio.get("/s6/weather?key=8c1c2b0cae5b422a8938a75c669976cc&location=$city");

    debugPrint(response.toString());

    return WeatherData.fromJson(response.data);
  }

  Future<WeatherAirData> getAir({@required String city}) async {
    final response =
        await dio.get("/s6/air/now?key=8c1c2b0cae5b422a8938a75c669976cc&location=$city");

    debugPrint(response.toString());

    return WeatherAirData.fromJson(response.data);
  }
}
