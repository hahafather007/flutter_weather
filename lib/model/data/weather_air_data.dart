class WeatherAirData {
  List<WeatherAir> weatherAir;

  WeatherAirData({this.weatherAir});

  WeatherAirData.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    if (json['HeWeather6'] != null) {
      weatherAir = List<WeatherAir>();
      json['HeWeather6'].forEach((v) {
        weatherAir.add(WeatherAir.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.weatherAir != null) {
      data['HeWeather6'] = this.weatherAir.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class WeatherAir {
  String status;
  AirNowCity airNowCity;

  WeatherAir({this.status, this.airNowCity});

  WeatherAir.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    status = json['status'];
    airNowCity = json['air_now_city'] != null
        ? AirNowCity.fromJson(json['air_now_city'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.airNowCity != null) {
      data['air_now_city'] = this.airNowCity.toJson();
    }
    return data;
  }
}

class AirNowCity {
  String aqi;
  String qlty;
  String main;
  String pm25;
  String pm10;
  String no2;
  String so2;
  String co;
  String o3;
  String pubTime;

  AirNowCity(
      {this.aqi,
      this.qlty,
      this.main,
      this.pm25,
      this.pm10,
      this.no2,
      this.so2,
      this.co,
      this.o3,
      this.pubTime});

  AirNowCity.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    aqi = json['aqi'];
    qlty = json['qlty'];
    main = json['main'];
    pm25 = json['pm25'];
    pm10 = json['pm10'];
    no2 = json['no2'];
    so2 = json['so2'];
    co = json['co'];
    o3 = json['o3'];
    pubTime = json['pub_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['aqi'] = this.aqi;
    data['qlty'] = this.qlty;
    data['main'] = this.main;
    data['pm25'] = this.pm25;
    data['pm10'] = this.pm10;
    data['no2'] = this.no2;
    data['so2'] = this.so2;
    data['co'] = this.co;
    data['o3'] = this.o3;
    data['pub_time'] = this.pubTime;
    return data;
  }
}
