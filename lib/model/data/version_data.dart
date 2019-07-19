class VersionData {
  int version;
  String size;
  String url;
  String time;

  VersionData({this.version, this.size, this.url, this.time});

  VersionData.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    size = json['size'];
    url = json['url'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['size'] = this.size;
    data['url'] = this.url;
    data['time'] = this.time;
    return data;
  }
}
