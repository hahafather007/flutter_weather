class ReadTitle {
  String sId;
  String coverImageUrl;
  String desc;
  String title;
  String type;

  ReadTitle({this.sId, this.coverImageUrl, this.desc, this.title, this.type});

  ReadTitle.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    sId = json['_id'];
    coverImageUrl = json['coverImageUrl'];
    desc = json['desc'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['coverImageUrl'] = this.coverImageUrl;
    data['desc'] = this.desc;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}

class ReadData {
  String name;
  String from;
  String updateTime;
  String url;
  String icon;

  ReadData({this.name, this.from, this.updateTime, this.url, this.icon});

  ReadData.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    name = json['name'];
    from = json['from'];
    updateTime = json['updateTime'];
    url = json['url'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['from'] = this.from;
    data['updateTime'] = this.updateTime;
    data['url'] = this.url;
    data['icon'] = this.icon;
    return data;
  }
}
