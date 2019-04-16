import 'package:flutter_weather/commom_import.dart';

/// 雪花
class SnowView extends StatefulWidget {
  /// 是否为全屏下雪
  final bool fullScreen;

  SnowView({this.fullScreen = false});

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
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: (Random().nextDouble() * 8000 + 4000).toInt()))
      ..forward()
      ..addListener(() {
        if (_anim.value <= -20) {
          _initStartData();
          _controller
            ..reset()
            ..forward();
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initStartData();
    _anim = Tween(begin: _bottomBegin, end: _bottomBegin - _fullHeight - 20)
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
          left: _left + (widget.fullScreen ? 0 : (260 - _anim.value) / 3),
          bottom: _anim.value,
        );
      },
    );
  }

  /// 初始化雪花开始的数据
  void _initStartData() {
    _alpha = Random().nextInt(140) + 60;
    _size = Random().nextDouble() * 12;

    if (!widget.fullScreen) {
      _left = getScreenWidth(context) - Random().nextInt(280) - 40;
      _bottomBegin = Random().nextDouble() * 120 + 180;
    } else {
      _left = Random().nextDouble() * (getScreenWidth(context) - 12);
      final paddingTop = _fullHeight - 100;
      _bottomBegin =
          Random().nextDouble() * (_fullHeight - paddingTop) + paddingTop;
    }
  }

  double get _fullHeight =>
      getScreenHeight(context) -
      getStatusHeight(context) -
      getAppBarHeight() -
      110;
}
