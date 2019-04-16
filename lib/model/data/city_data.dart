class Province {
  String name;
  String id;

  Province({this.name, this.id});

  Province.fromJson(Map<String, dynamic> json) {
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

class City {
  String province;
  String name;
  String id;

  City({this.province, this.name, this.id});

  City.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province'] = this.province;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class District {
  String city;
  String name;
  String id;

  District({this.city, this.name, this.id});

  District.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
