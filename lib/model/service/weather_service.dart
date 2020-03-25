import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/service/service.dart';
import 'package:flutter_weather/utils/log_util.dart';

class WeatherService extends Service {
  WeatherService() {
    dio.options.baseUrl = "https://free-api.heweather.net";
  }

  Future<WeatherData> getWeather({@required String city}) async {
    final response = await dio.get(
        "/s6/weather?key=2d2a76fac8324146a1b17b68bda42c76&location=$city&lang=${WeatherApp.locale?.languageCode == "zh" ? "" : "en"}",
        cancelToken: cancelToken);

    response.logStr();

    return WeatherData.fromJson(response.data);
  }

  Future<WeatherAirData> getAir({@required String city}) async {
    final response = await dio.get(
        "/s6/air/now?key=2d2a76fac8324146a1b17b68bda42c76&location=$city&lang=${WeatherApp.locale?.languageCode == "zh" ? "" : "en"}",
        cancelToken: cancelToken);

    response.logStr();

    return WeatherAirData.fromJson(response.data);
  }
}
