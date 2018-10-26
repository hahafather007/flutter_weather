import 'package:flutter_weather/commom_import.dart';

/// 带有圆形加载进度条的Stack
class LoadingView extends StatelessWidget {
  final bool loading;
  final Widget child;

  LoadingView(this.loading, {@required Widget child})
      : this.child = child,
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Offstage(
          offstage: !loading,
          child: Center(
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: AppColor.colorMain),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}
