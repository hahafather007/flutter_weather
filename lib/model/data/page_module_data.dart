class PageModule {
  PageType page;
  bool open;

  PageModule({this.page, this.open});

  PageModule.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    switch (json["page"]) {
      case "weather":
        page = PageType.WEATHER;
        break;
      case "gift":
        page = PageType.GIFT;
        break;
      case "read":
        page = PageType.READ;
        break;
      case "ganhuo":
        page = PageType.GANHUO;
        break;
      case "collect":
        page = PageType.COLLECT;
        break;
    }
    open = json["open"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    switch (page) {
      case PageType.WEATHER:
        data["page"] = "weather";
        break;
      case PageType.GIFT:
        data["page"] = "gift";
        break;
      case PageType.READ:
        data["page"] = "read";
        break;
      case PageType.GANHUO:
        data["page"] = "ganhuo";
        break;
      case PageType.COLLECT:
        data["page"] = "collect";
        break;
    }
    data["open"] = this.open;

    return data;
  }
}

enum PageType {
  /// 天气页面
  WEATHER,

  /// 福利页面
  GIFT,

  /// 闲读页面
  READ,

  /// 干货页面
  GANHUO,

  /// 收藏页面
  COLLECT,
}
