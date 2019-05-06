class VersionData {
  int version;
  String url;

  VersionData(
      {this.version, this.url});

  VersionData.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['url'] = this.url;
    return data;
  }
}
