import 'package:flutter_weather/commom_import.dart';

/// 雨点
class RainView extends StatefulWidget {
  /// 是否为大风天
  final bool bigWind;

  RainView({this.bigWind = true});

  @override
  State createState() => _RainState();
}

class _RainState extends State<RainView> with TickerProviderStateMixin {
  /// 雨点透明度
  int _alpha;

  /// 初始距离左侧边距
  double _left;

  double _bottomBegin;

  /// 运动动画
  AnimationController _controller;
  Animation<double> _anim;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initStartData();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward()
          ..addListener(() {
            if (_anim.value <= -20) {
              _initStartData();
              _controller
                ..reset()
                ..forward();
            }
          });
    _anim = Tween(begin: _bottomBegin, end: _bottomBegin - 320)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Positioned(
          child: Transform.rotate(
            angle: -pi / (widget.bigWind ? 6 : 9),
            child: Container(
              height: 20,
              width: 1,
              color: Colors.white.withAlpha(_alpha),
            ),
          ),
          left: _left + (260 - _anim.value) / (widget.bigWind ? 2 : 3),
          bottom: _anim.value,
        );
      },
    );
  }

  /// 初始化雨点开始的数据
  void _initStartData() {
    _left = getScreenWidth(context) - Random().nextInt(240) - 100;
    _alpha = Random().nextInt(140) + 30;
    _bottomBegin = Random().nextDouble() * 300;
  }
}
