class LocationData {
  String status;
  String info;
  String infoCode;
  String province;
  String city;
  String adCode;
  String rectangle;

  LocationData(
      {this.status,
      this.info,
      this.infoCode,
      this.province,
      this.city,
      this.adCode,
      this.rectangle});

  LocationData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    info = json['info'];
    infoCode = json['infocode'];
    province = json['province'];
    city = json['city'];
    adCode = json['adcode'];
    rectangle = json['rectangle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['info'] = this.info;
    data['infocode'] = this.infoCode;
    data['province'] = this.province;
    data['city'] = this.city;
    data['adcode'] = this.adCode;
    data['rectangle'] = this.rectangle;
    return data;
  }
}
