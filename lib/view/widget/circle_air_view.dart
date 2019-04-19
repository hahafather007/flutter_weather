import 'package:flutter_weather/commom_import.dart';

/// 空气质量指数环形图
class CircleAirView extends StatefulWidget {
  /// 空气指数
  final double aqi;

  /// 等级
  final String qlty;

  CircleAirView({Key key, @required this.aqi, @required this.qlty})
      : super(key: key);

  @override
  State createState() => _CircleAirState();
}

class _CircleAirState extends PageState<CircleAirView>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _numAnim;
  Animation<Color> _colorAnim;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _initAndStartAnim();
    bindSub(EventSendHolder()
        .event
        .where((pair) => pair.a == "CircleAirViewAnimation")
        .where((_) => _controller.value == 0)
        .listen((_) => _controller
          ..reset()
          ..forward()));
  }

  @override
  void didUpdateWidget(CircleAirView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.aqi != oldWidget.aqi) {
      _initAndStartAnim();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _numAnim,
      builder: (context, child) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _colorAnim,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _CircleAirPainter(
                        _numAnim.value.toDouble(), _colorAnim.value),
                  );
                },
              ),
              bottom: 60,
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  "${_numAnim.value}",
                  style: TextStyle(fontSize: 14, color: AppColor.colorText2),
                ),
              ),
              bottom: 10,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: AqiUtil.getAqiColor(widget.aqi),
                    borderRadius: BorderRadius.circular(2)),
                child: Text(
                  widget.qlty,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _initAndStartAnim() {
    _numAnim = IntTween(begin: 0, end: widget.aqi.round())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _colorAnim = ColorTween(
            begin: AqiUtil.getAqiColor(0), end: AqiUtil.getAqiColor(widget.aqi))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.reset();
    _controller.forward();
  }
}

class _CircleAirPainter extends CustomPainter {
  final double aqi;
  final Color color;

  _CircleAirPainter(this.aqi, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 圆心
    final center = Offset(size.width / 2, size.height * 3 / 4);
    // 起始角
    final startAngle = -pi * 5 / 4;
    // 结束角
    final endAngle = pi * 1 / 4;

    // 背景
    paint.color = const Color(0xff979797);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        startAngle, endAngle - startAngle, false, paint);

    final maxApi = aqi >= 400 ? 400 : aqi;
    // 进度
    paint.color = color;
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        startAngle, (endAngle - startAngle) * (maxApi / 400), false, paint);
  }

  @override
  bool shouldRepaint(_CircleAirPainter oldDelegate) {
    return aqi != oldDelegate.aqi || color != oldDelegate.color;
  }
}
