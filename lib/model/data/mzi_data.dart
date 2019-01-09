class MziData {
  String url;
  String link;
  String refer;
  int height;
  int width;
  bool isImages;

  MziData(
      {this.url,
      this.link,
      this.refer,
      this.height,
      this.width,
      this.isImages});

  MziData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    link = json['link'];
    refer = json['refer'];
    height = json['height'];
    width = json['width'];
    isImages = json['isImages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['link'] = this.link;
    data['refer'] = this.refer;
    data['height'] = this.height;
    data['width'] = this.width;
    data['isImages'] = this.isImages;
    return data;
  }
}
