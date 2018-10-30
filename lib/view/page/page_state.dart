import 'package:flutter_weather/commom_import.dart';

abstract class PageState<T extends StatefulWidget> extends State<T> {
  final scafKey = GlobalKey<ScaffoldState>();
  final loadingKey = GlobalKey<LoadingState>();

  /// 网络错误
  void networkError() {}
}
