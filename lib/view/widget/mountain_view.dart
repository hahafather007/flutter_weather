import 'package:flutter_weather/commom_import.dart';
import 'dart:math';
import 'dart:ui';

class MountainView extends StatefulWidget {
  @override
  State createState() => _MountainState();
}

class _MountainState extends State<MountainView> with TickerProviderStateMixin {
  /// 山的动画
  AnimationController _mountainController;
  Animation<double> _mountainAnim;

  @override
  void initState() {
    super.initState();

    _mountainController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..forward();
    _mountainAnim = Tween(begin: 0.0, end: 88.0).animate(CurvedAnimation(
        parent: _mountainController, curve: const Cubic(0.4, 0.8, 0.75, 1.3)));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mountainController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = getScreenWidth(context);

    return AnimatedBuilder(
      animation: _mountainAnim,
      builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            CustomPaint(
              size: Size(width, 120),
              painter: _MountainPainter(
                  _mountainAnim.value, width * 1 / 7, const Color(0xFF6484A8)),
            ),
            CustomPaint(
              size: Size(width, 120),
              painter: _MountainPainter(
                  _mountainAnim.value, width * 6 / 7, const Color(0xFF59789D)),
            ),
          ],
        );
      },
    );
  }
}

/// 缓存的Y轴点
final _sinCache = Map<double, double>();

/// 获得y轴坐标
double _getSinY(double xPoint, double width) {
  final x = xPoint.roundToDouble();

  // 自动判断是否需要重新计算缓存点，节约开销
  if (_sinCache[x] == null) {
    _sinCache[x] = sin(pi / 2 * x / width);
  }

  return _sinCache[x];
}

class _MountainPainter extends CustomPainter {
  /// 山的高度
  final double height;

  /// 距离左侧的偏移
  final double offset;

  /// 颜色
  final Color color;

  _MountainPainter(this.height, this.offset, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = color
      ..style = PaintingStyle.stroke;

    for (double i = 0; i <= size.width; i++) {
      canvas.drawLine(
          Offset(i, size.height),
          Offset(i, size.height - height * _getSinY(i + offset, size.width)),
          paint);
    }
  }

  @override
  bool shouldRepaint(_MountainPainter oldDelegate) {
    final heightChanged = height != oldDelegate.height;
    if (heightChanged) {
      _sinCache.clear();
    }

    return heightChanged;
  }
}
