class WeatherData {
  List<Weather> weathers;

  WeatherData({this.weathers});

  WeatherData.fromJson(Map<String, dynamic> json) {
    if (json['HeWeather6'] != null) {
      weathers = new List<Weather>();
      json['HeWeather6'].forEach((v) {
        weathers.add(new Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.weathers != null) {
      data['HeWeather6'] = this.weathers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  WeatherBasic basic;
  WeatherUpdate update;
  String status;
  WeatherNow now;
  List<WeatherDailyForecast> dailyForecast;
  List<WeatherHourly> hourly;
  List<WeatherLifestyle> lifestyle;

  Weather(
      {this.basic,
      this.update,
      this.status,
      this.now,
      this.dailyForecast,
      this.hourly,
      this.lifestyle});

  Weather.fromJson(Map<String, dynamic> json) {
    basic =
        json['basic'] != null ? new WeatherBasic.fromJson(json['basic']) : null;
    update = json['update'] != null
        ? new WeatherUpdate.fromJson(json['update'])
        : null;
    status = json['status'];
    now = json['now'] != null ? new WeatherNow.fromJson(json['now']) : null;
    if (json['daily_forecast'] != null) {
      dailyForecast = new List<WeatherDailyForecast>();
      json['daily_forecast'].forEach((v) {
        dailyForecast.add(new WeatherDailyForecast.fromJson(v));
      });
    }
    if (json['hourly'] != null) {
      hourly = new List<WeatherHourly>();
      json['hourly'].forEach((v) {
        hourly.add(new WeatherHourly.fromJson(v));
      });
    }
    if (json['lifestyle'] != null) {
      lifestyle = new List<WeatherLifestyle>();
      json['lifestyle'].forEach((v) {
        lifestyle.add(new WeatherLifestyle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.basic != null) {
      data['basic'] = this.basic.toJson();
    }
    if (this.update != null) {
      data['update'] = this.update.toJson();
    }
    data['status'] = this.status;
    if (this.now != null) {
      data['now'] = this.now.toJson();
    }
    if (this.dailyForecast != null) {
      data['daily_forecast'] =
          this.dailyForecast.map((v) => v.toJson()).toList();
    }
    if (this.hourly != null) {
      data['hourly'] = this.hourly.map((v) => v.toJson()).toList();
    }
    if (this.lifestyle != null) {
      data['lifestyle'] = this.lifestyle.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeatherBasic {
  String cid;
  String location;
  String parentCity;
  String adminArea;
  String cnty;
  String lat;
  String lon;
  String tz;

  WeatherBasic(
      {this.cid,
      this.location,
      this.parentCity,
      this.adminArea,
      this.cnty,
      this.lat,
      this.lon,
      this.tz});

  WeatherBasic.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    location = json['location'];
    parentCity = json['parent_city'];
    adminArea = json['admin_area'];
    cnty = json['cnty'];
    lat = json['lat'];
    lon = json['lon'];
    tz = json['tz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['location'] = this.location;
    data['parent_city'] = this.parentCity;
    data['admin_area'] = this.adminArea;
    data['cnty'] = this.cnty;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['tz'] = this.tz;
    return data;
  }
}

class WeatherUpdate {
  String loc;
  String utc;

  WeatherUpdate({this.loc, this.utc});

  WeatherUpdate.fromJson(Map<String, dynamic> json) {
    loc = json['loc'];
    utc = json['utc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loc'] = this.loc;
    data['utc'] = this.utc;
    return data;
  }
}

class WeatherNow {
  String cloud;
  String condCode;
  String condTxt;
  String fl;
  String hum;
  String pcpn;
  String pres;
  String tmp;
  String vis;
  String windDeg;
  String windDir;
  String windSc;
  String windSpd;

  WeatherNow(
      {this.cloud,
      this.condCode,
      this.condTxt,
      this.fl,
      this.hum,
      this.pcpn,
      this.pres,
      this.tmp,
      this.vis,
      this.windDeg,
      this.windDir,
      this.windSc,
      this.windSpd});

  WeatherNow.fromJson(Map<String, dynamic> json) {
    cloud = json['cloud'];
    condCode = json['cond_code'];
    condTxt = json['cond_txt'];
    fl = json['fl'];
    hum = json['hum'];
    pcpn = json['pcpn'];
    pres = json['pres'];
    tmp = json['tmp'];
    vis = json['vis'];
    windDeg = json['wind_deg'];
    windDir = json['wind_dir'];
    windSc = json['wind_sc'];
    windSpd = json['wind_spd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cloud'] = this.cloud;
    data['cond_code'] = this.condCode;
    data['cond_txt'] = this.condTxt;
    data['fl'] = this.fl;
    data['hum'] = this.hum;
    data['pcpn'] = this.pcpn;
    data['pres'] = this.pres;
    data['tmp'] = this.tmp;
    data['vis'] = this.vis;
    data['wind_deg'] = this.windDeg;
    data['wind_dir'] = this.windDir;
    data['wind_sc'] = this.windSc;
    data['wind_spd'] = this.windSpd;
    return data;
  }
}

class WeatherDailyForecast {
  String condCodeD;
  String condCodeN;
  String condTxtD;
  String condTxtN;
  String date;
  String hum;
  String mr;
  String ms;
  String pcpn;
  String pop;
  String pres;
  String sr;
  String ss;
  String tmpMax;
  String tmpMin;
  String uvIndex;
  String vis;
  String windDeg;
  String windDir;
  String windSc;
  String windSpd;

  WeatherDailyForecast(
      {this.condCodeD,
      this.condCodeN,
      this.condTxtD,
      this.condTxtN,
      this.date,
      this.hum,
      this.mr,
      this.ms,
      this.pcpn,
      this.pop,
      this.pres,
      this.sr,
      this.ss,
      this.tmpMax,
      this.tmpMin,
      this.uvIndex,
      this.vis,
      this.windDeg,
      this.windDir,
      this.windSc,
      this.windSpd});

  WeatherDailyForecast.fromJson(Map<String, dynamic> json) {
    condCodeD = json['cond_code_d'];
    condCodeN = json['cond_code_n'];
    condTxtD = json['cond_txt_d'];
    condTxtN = json['cond_txt_n'];
    date = json['date'];
    hum = json['hum'];
    mr = json['mr'];
    ms = json['ms'];
    pcpn = json['pcpn'];
    pop = json['pop'];
    pres = json['pres'];
    sr = json['sr'];
    ss = json['ss'];
    tmpMax = json['tmp_max'];
    tmpMin = json['tmp_min'];
    uvIndex = json['uv_index'];
    vis = json['vis'];
    windDeg = json['wind_deg'];
    windDir = json['wind_dir'];
    windSc = json['wind_sc'];
    windSpd = json['wind_spd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cond_code_d'] = this.condCodeD;
    data['cond_code_n'] = this.condCodeN;
    data['cond_txt_d'] = this.condTxtD;
    data['cond_txt_n'] = this.condTxtN;
    data['date'] = this.date;
    data['hum'] = this.hum;
    data['mr'] = this.mr;
    data['ms'] = this.ms;
    data['pcpn'] = this.pcpn;
    data['pop'] = this.pop;
    data['pres'] = this.pres;
    data['sr'] = this.sr;
    data['ss'] = this.ss;
    data['tmp_max'] = this.tmpMax;
    data['tmp_min'] = this.tmpMin;
    data['uv_index'] = this.uvIndex;
    data['vis'] = this.vis;
    data['wind_deg'] = this.windDeg;
    data['wind_dir'] = this.windDir;
    data['wind_sc'] = this.windSc;
    data['wind_spd'] = this.windSpd;
    return data;
  }
}

class WeatherHourly {
  String cloud;
  String condCode;
  String condTxt;
  String dew;
  String hum;
  String pop;
  String pres;
  String time;
  String tmp;
  String windDeg;
  String windDir;
  String windSc;
  String windSpd;

  WeatherHourly(
      {this.cloud,
      this.condCode,
      this.condTxt,
      this.dew,
      this.hum,
      this.pop,
      this.pres,
      this.time,
      this.tmp,
      this.windDeg,
      this.windDir,
      this.windSc,
      this.windSpd});

  WeatherHourly.fromJson(Map<String, dynamic> json) {
    cloud = json['cloud'];
    condCode = json['cond_code'];
    condTxt = json['cond_txt'];
    dew = json['dew'];
    hum = json['hum'];
    pop = json['pop'];
    pres = json['pres'];
    time = json['time'];
    tmp = json['tmp'];
    windDeg = json['wind_deg'];
    windDir = json['wind_dir'];
    windSc = json['wind_sc'];
    windSpd = json['wind_spd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cloud'] = this.cloud;
    data['cond_code'] = this.condCode;
    data['cond_txt'] = this.condTxt;
    data['dew'] = this.dew;
    data['hum'] = this.hum;
    data['pop'] = this.pop;
    data['pres'] = this.pres;
    data['time'] = this.time;
    data['tmp'] = this.tmp;
    data['wind_deg'] = this.windDeg;
    data['wind_dir'] = this.windDir;
    data['wind_sc'] = this.windSc;
    data['wind_spd'] = this.windSpd;
    return data;
  }
}

class WeatherLifestyle {
  String type;
  String brf;
  String txt;

  WeatherLifestyle({this.type, this.brf, this.txt});

  WeatherLifestyle.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    brf = json['brf'];
    txt = json['txt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['brf'] = this.brf;
    data['txt'] = this.txt;
    return data;
  }
}
