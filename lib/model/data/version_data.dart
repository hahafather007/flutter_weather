class VersionData {
  int version;
  String size;
  String url;

  VersionData({this.version, this.size, this.url});

  VersionData.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['size'] = this.size;
    data['url'] = this.url;
    return data;
  }
}
