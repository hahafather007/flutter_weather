import 'package:flutter/material.dart';
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

  final double height;

  final double width;

  WaveView(
      {@required this.amplitude,
        @required this.color,
        this.width,
        this.height,
        this.cycle = 4000,
        this.direction = WaveDirection.RIGHT,
        this.waveNum = 1})
      : assert(height != null || width != null);

  @override
  State createState() =>
      _WaveState(amplitude, color, width, height, cycle, direction, waveNum);
}

class _WaveState extends State<WaveView> with TickerProviderStateMixin {
  final double amplitude;

  final Color color;

  final int waveNum;

  final int cycle;

  final WaveDirection direction;

  final double height;

  final double width;

  AnimationController _controller;

  _WaveState(this.amplitude, this.color, this.width, this.height, this.cycle,
      this.direction, this.waveNum);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: cycle))
      ..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offsetX = direction == WaveDirection.LEFT
            ? _controller.value
            : -_controller.value;

        return CustomPaint(
          size: Size(width ?? double.infinity, height ?? double.infinity),
          painter: WavePainter(amplitude, offsetX, color, waveNum),
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

class WavePainter extends CustomPainter {
  /// 振幅
  final double amplitude;

  /// 波浪颜色
  final Color color;

  /// x轴偏移量
  final double offsetX;

  /// 波浪的数量
  final int waveNum;

  /// 缓存的Y轴点
  final _sinCache = Map<double, double>();

  /// 每个绘制线条的透明度
  final _opacityCache = Map<double, double>();

  /// 每一层波浪的偏移量
  final _waveOffsets = Map<int, double>();

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

        if (_waveOffsets[index] == null) {
          _waveOffsets[index] = index / waveNum / 2 * size.width;
        }
        canvas.drawLine(
            Offset(i, size.height),
            Offset(i, _getSinY(i + _waveOffsets[index], size.width) + _centerY),
            paint);
      }
    });
  }

  /// 获得y轴坐标
  double _getSinY(double xPoint, double width) {
    // 自动判断是否需要重新计算缓存点，节约开销
    if (_sinCache[xPoint] == null) {
      _sinCache[xPoint] =
          amplitude * sin(2 * pi * xPoint / width + offsetX * 2 * pi);
    }

    return _sinCache[xPoint];
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    final ampChange = amplitude != oldDelegate.amplitude;
    if (ampChange) {
      _sinCache.clear();
    }

    final waveNumChange = waveNum != oldDelegate.waveNum;
    if (waveNumChange) {
      _waveOffsets.clear();
    }

    return ampChange || offsetX != oldDelegate.offsetX || waveNumChange;
  }
}
