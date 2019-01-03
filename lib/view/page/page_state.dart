import 'package:flutter_weather/commom_import.dart';

abstract class PageState<T extends StatefulWidget> extends State<T>
    with StreamSubController {
  final scafKey = GlobalKey<ScaffoldState>();

  /// 网络错误
  void networkError() {}

  @override
  void dispose() {
    subDispose();

    super.dispose();
  }
}
