class GankTitle {
  String sId;
  String coverImageUrl;
  String desc;
  String title;
  String type;

  GankTitle({this.sId, this.coverImageUrl, this.desc, this.title, this.type});

  GankTitle.fromJson(Map<String, dynamic> json) {
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

class GankData {
  List<GankItem> data;
  int page;
  int pageCount;
  int status;
  int totalCounts;

  GankData(
      {this.data, this.page, this.pageCount, this.status, this.totalCounts});

  GankData.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    if (json['data'] != null) {
      data = List<GankItem>();
      json['data'].forEach((v) {
        data.add(GankItem.fromJson(v));
      });
    }
    page = json['page'];
    pageCount = json['page_count'];
    status = json['status'];
    totalCounts = json['total_counts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v?.toJson()).toList();
    }
    data['page'] = this.page;
    data['page_count'] = this.pageCount;
    data['status'] = this.status;
    data['total_counts'] = this.totalCounts;
    return data;
  }
}

class GankItem {
  String sId;
  String author;
  String category;
  String createdAt;
  String desc;
  List<String> images;
  int likeCounts;
  String publishedAt;
  int stars;
  String title;
  String type;
  String url;
  int views;

  GankItem(
      {this.sId,
      this.author,
      this.category,
      this.createdAt,
      this.desc,
      this.images,
      this.likeCounts,
      this.publishedAt,
      this.stars,
      this.title,
      this.type,
      this.url,
      this.views});

  GankItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    sId = json['_id'];
    author = json['author'];
    category = json['category'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    images = json['images'].cast<String>();
    likeCounts = json['likeCounts'];
    publishedAt = json['publishedAt'];
    stars = json['stars'];
    title = json['title'];
    type = json['type'];
    url = json['url'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['author'] = this.author;
    data['category'] = this.category;
    data['createdAt'] = this.createdAt;
    data['desc'] = this.desc;
    data['images'] = this.images;
    data['likeCounts'] = this.likeCounts;
    data['publishedAt'] = this.publishedAt;
    data['stars'] = this.stars;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    data['views'] = this.views;
    return data;
  }
}
