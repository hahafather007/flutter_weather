import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather/utils/system_util.dart';

/// 波浪控件
class WaveView extends StatefulWidget {
  /// 振幅
  final double amplitude;

  /// 振幅显示的百分比
  final double amplitudePercent;

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
      this.amplitudePercent = 1,
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
    // widget宽和高
    final width = widget.width ?? getScreenWidth(context);
    final height =
        (widget.height ?? getScreenHeight(context)) - widget.imgSize.width / 2;
    // cos对应2*pi长度时的高度
    final cosHeight = widget.amplitude * (2 * pi) / width;
    // 小船吃水高度
    const eatWater = 2;
    // 小船的x坐标
    final boatX = width - widget.imgRight - widget.imgSize.width / 2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offsetX = widget.direction == WaveDirection.LEFT
            ? _controller.value
            : -_controller.value;

        return Container(
          height: height + widget.imgSize.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              widget.waveNum > 1
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: List.generate(widget.waveNum - 1, (index) {
                        return CustomPaint(
                          willChange: true,
                          isComplex: true,
                          size: Size(width, height),
                          painter: _WavePainter(
                            widget.amplitude,
                            widget.amplitudePercent,
                            offsetX,
                            widget.color,
                            widget.waveNum,
                            index + 1,
                          ),
                        );
                      }),
                    )
                  : Container(),

              // 浮动的图片
              widget.imgUrl != null
                  ? Positioned(
                      child: RepaintBoundary(
                        child: Transform.rotate(
                          angle:
                          _getSinY(boatX, width, offsetX + 0.25) * cosHeight,
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
                      ),
                      right: widget.imgRight,
                      bottom: height -
                          widget.amplitude *
                              (1 +
                                  widget.amplitudePercent *
                                      _getSinY(boatX, width, offsetX)) -
                          widget.imgSize.height -
                          eatWater,
                    )
                  : Container(),

              // 第一层波浪
              CustomPaint(
                willChange: true,
                isComplex: true,
                size: Size(width, height),
                painter: _WavePainter(
                  widget.amplitude,
                  widget.amplitudePercent,
                  offsetX,
                  widget.color,
                  widget.waveNum,
                  0,
                ),
              ),
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

class _WavePainter extends CustomPainter {
  /// 振幅
  final double amplitude;

  /// 振幅显示的百分比
  final double amplitudePercent;

  /// 波浪颜色
  final Color color;

  /// x轴偏移量
  final double offsetX;

  /// 波浪的数量
  final int waveNum;

  /// 第几条波浪
  final int waveIndex;

  /// y轴的中心点
  double _centerY;

  _WavePainter(this.amplitude, this.amplitudePercent, this.offsetX, this.color,
      this.waveNum, this.waveIndex);

  @override
  void paint(Canvas canvas, Size size) {
    _centerY = amplitude;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [color.withOpacity(0.12), color.withOpacity(0.6)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final path = Path()..moveTo(0, size.height);
    final waveOffset = (waveIndex / waveNum / 2 * size.width).roundToDouble();

    for (double i = 0; i <= size.width; i++) {
      final sinY = amplitude *
          amplitudePercent *
          _getSinY(i + waveOffset, size.width, offsetX);

      path.lineTo(i, sinY + _centerY);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    final ampChange = amplitude != oldDelegate.amplitude;
    final percentChange = amplitudePercent != oldDelegate.amplitudePercent;
    if (ampChange || percentChange) {
      _sinCache.clear();
    }

    return ampChange ||
        percentChange ||
        offsetX != oldDelegate.offsetX ||
        waveNum != oldDelegate.waveNum;
  }
}
