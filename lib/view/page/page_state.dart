import 'package:flutter_weather/commom_import.dart';
import 'dart:ui' as Ui;

abstract class PageState<T extends StatefulWidget> extends State<T>
    with StreamSubController {
  @protected
  final scafKey = GlobalKey<ScaffoldState>();
  @protected
  final boundaryKey = GlobalKey();

  bool _bindError = false;

  /// 获取屏幕截图
  @protected
  Future<File> takeScreenshot() async {
    final boundary =
        boundaryKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);
    final directory = (await getApplicationDocumentsDirectory()).path;
    final byteData = await image.toByteData(format: Ui.ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    final file = await File(
            "$directory/weather_${DateTime.now().millisecondsSinceEpoch}.png")
        .writeAsBytes(pngBytes);

    return file;
  }

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

  void showSnack({@required String text}) {
    scafKey.currentState.removeCurrentSnackBar();
    scafKey.currentState.showSnackBar(SnackBar(
        content: Text(text), duration: const Duration(milliseconds: 2000)));
  }

  @override
  void dispose() {
    subDispose();

    super.dispose();
  }
}
