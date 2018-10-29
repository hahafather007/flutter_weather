import 'package:flutter_weather/commom_import.dart';

/// 带有圆形加载进度条的Stack
class RefreshView extends StatelessWidget {
  final bool loading;
  final Widget child;

  RefreshView(this.loading, {@required Widget child})
      : this.child = child,
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Offstage(
          offstage: !loading,
          child: RefreshProgressIndicator(),
        ),
      ],
    );
  }
}
