import 'package:flutter_weather/commom_import.dart';

abstract class PageState<T extends StatefulWidget> extends State<T>
    with StreamSubController {
  @protected
  final scafKey = GlobalKey<ScaffoldState>();

  /// 绑定viewModel中通用的stream
  @protected
  void bindStreamOfViewModel(ViewModel viewModel) {
    bindSub(viewModel.error.stream.listen((_) => networkError()));
  }

  /// 网络错误
  @protected
  void networkError() {}

  @override
  void dispose() {
    subDispose();

    super.dispose();
  }
}
