class PageModule {
  String module;
  bool open;

  PageModule({this.module, this.open});

  PageModule.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module'] = this.module;
    data['open'] = this.open;
    return data;
  }
}
