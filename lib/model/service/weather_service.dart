import 'package:flutter_weather/commom_import.dart';

class WeatherService extends Service {
  WeatherService() {
    dio.options.baseUrl = "https://free-api.heweather.net";
  }

  Future<WeatherData> getWeather({@required String city}) async {
    final response =
        await dio.get("/s6/weather?key=2d2a76fac8324146a1b17b68bda42c76&location=$city");

    debugPrint(response.toString());

    return WeatherData.fromJson(response.data);
  }

  Future<WeatherAirData> getAir({@required String city}) async {
    final response =
        await dio.get("/s6/air/now?key=2d2a76fac8324146a1b17b68bda42c76&location=$city");

    debugPrint(response.toString());

    return WeatherAirData.fromJson(response.data);
  }
}
