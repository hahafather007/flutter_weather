class City {
  String province;
  String district;

  City({this.province, this.district});

  City.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province'] = this.province;
    data['district'] = this.district;
    return data;
  }
}

class District {
  String name;
  String id;

  District({this.name, this.id});

  District.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
