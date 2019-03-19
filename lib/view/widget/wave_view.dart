import 'package:flutter_weather/commom_import.dart';
import 'dart:math';
import 'dart:ui';

class WaveView extends StatefulWidget {
  /// 振幅
  final double amplitude;

  /// 波浪颜色
  final Color color;

  /// 波浪的数量
  final int waveNum;

  /// 波浪循环周期(毫秒)
  final int cycle;

  /// 波浪方向
  final WaveDirection direction;

  /// 随着波浪起伏的图片地址
  final String imgUrl;

  final Size imgSize;

  /// 图片距离右边屏幕的距离
  final double imgRight;

  final double height;

  final double width;

  WaveView(
      {@required this.amplitude,
      @required this.color,
      this.imgUrl,
      this.imgSize = const Size(60, 18),
      this.width,
      this.height,
      this.imgRight = 80,
      this.cycle = 4000,
      this.direction = WaveDirection.RIGHT,
      this.waveNum = 1})
      : assert(height != null || width != null);

  @override
  State createState() => _WaveState();
}

class _WaveState extends State<WaveView> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.cycle))
      ..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? getScreenWidth(context);
    final cosHeight = widget.amplitude * (2 * pi) / width;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offsetX = widget.direction == WaveDirection.LEFT
            ? _controller.value
            : -_controller.value;

        return Container(
          height: widget.height + 20,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              // 波浪
              CustomPaint(
                size: Size(width, widget.height ?? double.infinity),
                painter: WavePainter(
                    widget.amplitude, offsetX, widget.color, widget.waveNum),
              ),

              // 浮动的图片
              widget.imgUrl != null
                  ? Positioned(
                      child: Transform.rotate(
                        angle: _getSinY(
                                width -
                                    widget.imgRight -
                                    widget.imgSize.width / 2,
                                width,
                                offsetX + 0.25) *
                            cosHeight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              widget.imgUrl,
                              width: widget.imgSize.width,
                              height: widget.imgSize.height,
                            ),
                            Container(height: widget.imgSize.height),
                          ],
                        ),
                      ),
                      right: widget.imgRight,
                      bottom: widget.height -
                          widget.amplitude *
                              (1 +
                                  _getSinY(
                                      width -
                                          widget.imgRight -
                                          widget.imgSize.width / 2,
                                      width,
                                      offsetX)) -
                          widget.imgSize.height,
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}

/// 波浪流动方向
enum WaveDirection {
  LEFT,
  RIGHT,
}

/// 缓存的Y轴点
final _sinCache = Map<double, double>();

/// 获得y轴坐标
double _getSinY(double xPoint, double width, double xOffset) {
  final x = (xPoint + xOffset * width).roundToDouble();

  // 自动判断是否需要重新计算缓存点，节约开销
  if (_sinCache[x] == null) {
    _sinCache[x] = sin(2 * pi * x / width);
  }

  return _sinCache[x];
}

class WavePainter extends CustomPainter {
  /// 振幅
  final double amplitude;

  /// 波浪颜色
  final Color color;

  /// x轴偏移量
  final double offsetX;

  /// 波浪的数量
  final int waveNum;

  /// 每个绘制线条的透明度
  final _opacityCache = Map<double, double>();

  /// y轴的中心点
  double _centerY;

  WavePainter(this.amplitude, this.offsetX, this.color, this.waveNum);

  @override
  void paint(Canvas canvas, Size size) {
    _centerY = amplitude;

    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    List.generate(waveNum, (index) {
      for (double i = 1; i <= size.width; i++) {
        // 缓存线条透明度计算结果
        if (_opacityCache[i] == null) {
          _opacityCache[i] = (i / size.width) * 0.8 + 0.1;
        }
        paint.color = color.withOpacity(_opacityCache[i]);

        final _waveOffset = (index / waveNum / 2 * size.width).roundToDouble();
        final sinY = amplitude * _getSinY(i + _waveOffset, size.width, offsetX);

        canvas.drawLine(
            Offset(i, size.height), Offset(i, sinY + _centerY), paint);
      }
    });
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    final ampChange = amplitude != oldDelegate.amplitude;
    if (ampChange) {
      _sinCache.clear();
    }

    return ampChange ||
        offsetX != oldDelegate.offsetX ||
        waveNum != oldDelegate.waveNum;
  }
}
