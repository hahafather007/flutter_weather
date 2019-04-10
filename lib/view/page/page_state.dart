import 'package:flutter_weather/commom_import.dart';

abstract class PageState<T extends StatefulWidget> extends State<T>
    with StreamSubController {
  @protected
  final scafKey = GlobalKey<ScaffoldState>();

  bool _bindError = false;

  /// 绑定viewModel中通用的stream
  @protected
  void bindErrorStream(Stream<bool> error,
      {@required String errorText, @required Function retry}) {
    if (_bindError) return;
    _bindError = true;

    bindSub(error
        .where((b) => b)
        .listen((_) => _networkError(errorText: errorText, retry: retry)));
  }

  /// 网络错误
  void _networkError({@required String errorText, @required Function retry}) {
    scafKey.currentState.removeCurrentSnackBar();
    scafKey.currentState.showSnackBar(SnackBar(
      content: Text(errorText),
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: AppText.of(context).retry,
        onPressed: retry,
      ),
    ));
  }

  @override
  void dispose() {
    subDispose();

    super.dispose();
  }
}
