class ReadData {
  String name;
  String from;
  String updateTime;
  String url;
  String icon;

  ReadData({this.name, this.from, this.updateTime, this.url, this.icon});

  ReadData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    from = json['from'];
    updateTime = json['updateTime'];
    url = json['url'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['from'] = this.from;
    data['updateTime'] = this.updateTime;
    data['url'] = this.url;
    data['icon'] = this.icon;
    return data;
  }
}
