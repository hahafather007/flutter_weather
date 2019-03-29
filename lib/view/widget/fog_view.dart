import 'package:flutter_weather/commom_import.dart';

/// 雾天的控件
class FogView extends StatefulWidget {
  @override
  State createState() => _FogState();
}

class _FogState extends State<FogView> with TickerProviderStateMixin {
  /// 第一个雾
  AnimationController _controller;
  Animation<double> _anim;

  /// 第二个雾
  AnimationController _controller2;
  Animation<double> _anim2;

  Timer _initTimer;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller
                ..reset()
                ..forward();
            }
          });
    _controller2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller2
                ..reset()
                ..forward();
            }
          });
    _initTimer =
        Timer(const Duration(milliseconds: 2500), () => _controller2.forward());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _anim = Tween(begin: 0.0, end: getScreenWidth(context) / 2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _anim2 = Tween(begin: 0.0, end: getScreenWidth(context) / 2)
        .animate(CurvedAnimation(parent: _controller2, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller2?.dispose();
    _initTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = getScreenWidth(context);

    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            double opacity = 0.3;
            if (_anim.value > width / 3) {
              opacity -= 0.3 * (_anim.value - width / 3) / (width / 6);
            }

            return CustomPaint(
              size: Size(width, width / 2),
              painter: _FogPainter(_anim.value, opacity),
            );
          },
        ),
        AnimatedBuilder(
          animation: _anim2,
          builder: (context, child) {
            double opacity = 0.3;
            if (_anim2.value > width / 3) {
              opacity -= 0.3 * (_anim2.value - width / 3) / (width / 6);
            }

            return CustomPaint(
              size: Size(width, width / 2),
              painter: _FogPainter(_anim2.value, opacity),
            );
          },
        ),
      ],
    );
  }
}

class _FogPainter extends CustomPainter {
  /// 雾的半径
  final double radius;

  /// 透明度
  final double opacity;

  _FogPainter(this.radius, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height), radius, paint);
  }

  @override
  bool shouldRepaint(_FogPainter oldDelegate) {
    return radius != oldDelegate.radius || opacity != oldDelegate.opacity;
  }
}
