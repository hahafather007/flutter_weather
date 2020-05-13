/// 妹子图数据
class MziData {
  int page;
  int maxPage;
  List<MziItem> items;

  MziData(this.page, this.maxPage, this.items);
}

class MziItem {
  String url;
  String link;
  String refer;
  int height;
  int width;
  bool isImages;

  MziItem(
      {this.url,
      this.link,
      this.refer,
      this.height,
      this.width,
      this.isImages});

  MziItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    url = json['url'];
    link = json['link'];
    refer = json['refer'];
    height = json['height'];
    width = json['width'];
    isImages = json['isImages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    data['link'] = this.link;
    data['refer'] = this.refer;
    data['height'] = this.height;
    data['width'] = this.width;
    data['isImages'] = this.isImages;
    return data;
  }
}
