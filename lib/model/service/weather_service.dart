import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/service/service.dart';

class WeatherService extends Service {
  WeatherService() {
    dio.options.baseUrl = "https://free-api.heweather.net";
  }

  Future<WeatherData> getWeather({@required String city}) async {
    final response = await get(
        "/s6/weather?key=2d2a76fac8324146a1b17b68bda42c76&location=$city&lang=${WeatherApp.locale?.languageCode == "zh" ? "" : "en"}",
        cancelToken: cancelToken);

    return await compute(_formatWeather, response.data);
  }

  static WeatherData _formatWeather(data) {
    return WeatherData.fromJson(data);
  }

  Future<WeatherAirData> getAir({@required String city}) async {
    final response = await get(
        "/s6/air/now?key=2d2a76fac8324146a1b17b68bda42c76&location=$city&lang=${WeatherApp.locale?.languageCode == "zh" ? "" : "en"}",
        cancelToken: cancelToken);

    return await compute(_formatAir, response.data);
  }

  static WeatherAirData _formatAir(data) {
    return WeatherAirData.fromJson(data);
  }
}
