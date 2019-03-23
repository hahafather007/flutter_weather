import 'package:flutter_weather/commom_import.dart';

/// 雪花
class SnowView extends StatefulWidget {
  @override
  State createState() => _SnowState();
}

class _SnowState extends State<SnowView> with TickerProviderStateMixin {
  /// 雪花透明度
  int _alpha;

  /// 初始距离左侧边距
  double _left;

  /// 初始距离底部位置
  double _bottomBegin;

  /// 雪花大小
  double _size;

  /// 运动动画
  AnimationController _controller;
  Animation<double> _anim;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initStartData();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: Random().nextInt(6) + 4))
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
          child: Container(
            height: _size,
            width: _size,
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(_alpha), shape: BoxShape.circle),
          ),
          left: _left + (260 - _anim.value) / 3,
          bottom: _anim.value,
        );
      },
    );
  }

  /// 初始化雪花开始的数据
  void _initStartData() {
    _left = getScreenWidth(context) - Random().nextInt(280) - 40;
    _alpha = Random().nextInt(140) + 30;
    _bottomBegin = Random().nextDouble() * 120 + 180;
    _size = Random().nextDouble() * 12;
  }
}
