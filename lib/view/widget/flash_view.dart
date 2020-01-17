import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mixing.dart';

/// 打雷动画控件
class FlashView extends StatefulWidget {
  final double height;
  final double width;

  FlashView({@required this.height, @required this.width});

  @override
  State createState() => _FlashState();
}

class _FlashState extends State<FlashView> with TickerProviderStateMixin {
  /// 闪电慢慢形成的动画
  AnimationController _showController;
  Animation<double> _showAnim;

  /// 闪电粗细变化动画
  Animation<double> _widthAnim;

  /// 闪电隐藏动画
  AnimationController _hideController;

  /// 重置定时器
  Timer _resetTimer;
  Three<List<Offset>, List<Offset>, List<Offset>> paths;

  @override
  void initState() {
    super.initState();

    _calculatePaths();
    _showController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 隐藏闪电
          _hideController.forward();

          // 重置闪电
          _resetTimer?.cancel();
          _resetTimer = Timer(const Duration(seconds: 5), () {
            _calculatePaths();
            _showController.reset();
            _hideController.reset();
            _showController.forward();
          });
        }
      });
    _showAnim = Tween(begin: 0.0, end: 49.0).animate(
        CurvedAnimation(parent: _showController, curve: Curves.linear));
    _widthAnim = Tween(begin: 5.0, end: 1.0).animate(
        CurvedAnimation(parent: _showController, curve: Curves.linear));
    _hideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _showController?.dispose();
    _hideController?.dispose();
    _resetTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _showAnim,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _widthAnim,
          builder: (context, child) {
            return AnimatedBuilder(
              animation: _hideController,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - _hideController.value,
                  child: CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: _FlashPainter(
                        paths, _showAnim.value.round(), _widthAnim.value),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// 计算闪电路径
  void _calculatePaths() {
    final path1 = _randomPaths(
        Offset.zero, Offset(widget.width / 4 * 3, widget.height), 50);
    final path2 = List<Offset>()
      ..addAll(path1.sublist(0, 10))
      ..addAll(_randomPaths(
          path1[10], Offset(widget.width / 3 * 1, widget.height / 5 * 4), 20));
    final path3 = List<Offset>()
      ..addAll(path1.sublist(0, 30))
      ..addAll(_randomPaths(
          path1[30], Offset(widget.width, widget.height / 5 * 4), 20));

    paths = Three(path1, path2, path3);
  }

  /// 创建随机路径
  List<Offset> _randomPaths(Offset min, Offset max, int length) {
    final xPaths = List.generate(
        length - 2, (_) => Random().nextDouble() * (max.dx - min.dx) + min.dx)
      ..sort();
    final yPath = List.generate(
        length - 2, (_) => Random().nextDouble() * (max.dy - min.dy) + min.dy)
      ..sort();

    return List<Offset>()
      ..add(min)
      ..addAll(List.generate(
          length - 2, (index) => Offset(xPaths[index], yPath[index])))
      ..add(max);
  }
}

class _FlashPainter extends CustomPainter {
  /// 闪电的路径
  final Three<List<Offset>, List<Offset>, List<Offset>> paths;

  /// 闪电目前的位置
  final int index;

  /// 画笔宽度
  final double width;

  _FlashPainter(this.paths, this.index, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = width
      ..isAntiAlias = true
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    final maxA = index > paths.a.length - 1 ? paths.a.length - 1 : index;
    final pathA = Path()..moveTo(paths.a[0].dx, paths.a[0].dy);
    for (int i = 1; i < maxA; i++) {
      pathA.lineTo(paths.a[i].dx, paths.a[i].dy);
    }
    pathA.close();

    final maxB = index > paths.b.length - 1 ? paths.b.length - 1 : index;
    final pathB = Path()..moveTo(paths.b[0].dx, paths.b[0].dy);
    for (int i = 1; i < maxB; i++) {
      pathB.lineTo(paths.b[i].dx, paths.b[i].dy);
    }
    pathB.close();

    final maxC = index > paths.c.length - 1 ? paths.c.length - 1 : index;
    final pathC = Path()..moveTo(paths.c[0].dx, paths.c[0].dy);
    for (int i = 1; i < maxC; i++) {
      pathC.lineTo(paths.c[i].dx, paths.c[i].dy);
    }
    pathC.close();

    canvas.drawPath(pathA, paint);
    canvas.drawPath(pathB, paint);
    canvas.drawPath(pathC, paint);
  }

  @override
  bool shouldRepaint(_FlashPainter oldDelegate) =>
      oldDelegate.paths != paths || oldDelegate.index != index;
}
