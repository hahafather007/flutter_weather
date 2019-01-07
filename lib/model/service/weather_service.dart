import 'package:flutter_weather/commom_import.dart';

class WeatherService extends Service {
  WeatherService() {
    dio.options.baseUrl = "https://free-api.heweather.com";
  }

  Future<WeatherData> getWeather({@required String city}) async {
    final response =
        await dio.get("/s6/weather?key=${Keys.WEATHER_KEY}&location=$city");

    debugPrint(response.toString());

    return WeatherData.fromJson(response.data);
  }

  Future<WeatherAirData> getAir({@required String city}) async {
    final response =
        await dio.get("/s6/air/now?key=${Keys.WEATHER_KEY}&location=$city");

    debugPrint(response.toString());

    return WeatherAirData.fromJson(response.data);
  }
}
