import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/location_data.dart';
import 'package:flutter_weather/model/service/service.dart';

class LocationService extends Service {
  Future<LocationData> getLocation() async {
    final response = await dio.get(
        "https://restapi.amap.com/v3/ip?key=d30f5f6c21de42b9d17e82304c70b298",
        cancelToken: cancelToken);

    debugPrint(response.toString());

    return LocationData.fromJson(response.data);
  }
}
