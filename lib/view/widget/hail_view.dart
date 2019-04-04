import 'package:flutter_weather/commom_import.dart';

/// 冰雹
class HailView extends StatefulWidget {
  @override
  State createState() => _SnowState();
}

class _SnowState extends State<HailView> with TickerProviderStateMixin {
  /// 初始距离左侧边距
  double _left;

  /// 雪花大小
  double _size;

  /// 最大可显示高度
  double _height;

  /// 运动动画
  AnimationController _controller;
  Animation<double> _anim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: (Random().nextDouble() * 6000 + 2000).toInt()))
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
    _anim = Tween(begin: _fullHeight, end: -20.0)
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
        final color = Colors.white.withOpacity(_controller.value * 0.6 + 0.2);

        return Positioned(
          child: Container(
            height: _size / 3 * 4,
            width: _size,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                  child: Material(
                    color: color,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(_size / 6 * 5)),
                  ),
                ),
                Container(
                  width: _size / 3 * 2,
                  height: _size / 3 * 2,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: color),
                ),
              ],
            ),
          ),
          left: _left,
          bottom: _anim.value,
        );
      },
    );
  }

  /// 初始化雪花开始的数据
  void _initStartData() {
    _size = Random().nextDouble() * 12;
    _left = Random().nextDouble() * getScreenWidth(context);
  }

  double get _fullHeight {
    if (_height == null) {
      _height = getScreenHeight(context) -
          getStatusHeight(context) -
          getAppBarHeight() -
          110;
    }

    return _height;
  }
}
