class City {
  String province;
  String district;

  City({this.province, this.district});

  City.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    province = json['province'];
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    if (json == null) return;

    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
