class Location {
  String city;
  String district;

  Location({this.city, this.district});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['district'] = this.district;
    return data;
  }
}
