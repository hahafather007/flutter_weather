import 'package:flutter_weather/commom_import.dart';
import 'weather_base.dart';

class WeatherOvercast extends StatefulWidget {
  WeatherOvercast({Key key}) : super(key: key);

  @override
  State createState() => WeatherOvercastState();
}

class WeatherOvercastState extends WeatherBase<WeatherOvercast> {
  /// 山的动画
  AnimationController _mountainController;
  Animation<double> _mountainAnim;

  /// 风车移动动画
  AnimationController _carMoveController;
  Animation<double> _carMoveAnim;

  /// 风车旋转动画
  AnimationController _carRotateController;
  Animation<double> _carRotateAnim;

  /// 白云移动动画
  AnimationController _cloudController;
  Animation<double> _cloudAnim;

  @override
  void initState() {
    super.initState();

    _mountainController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..forward();
    _mountainAnim = Tween(begin: 0.0, end: 88.0).animate(CurvedAnimation(
        parent: _mountainController, curve: const Cubic(0.4, 0.8, 0.75, 1.3)));

    _carMoveController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..forward();
    _carMoveAnim = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _carMoveController, curve: const Cubic(0.4, 0.8, 0.75, 1.3)));

    _carRotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
    _carRotateAnim = Tween(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(parent: _carRotateController, curve: Curves.linear));

    _cloudController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30))
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _cloudController
                ..reset()
                ..forward();
            }
          });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cloudAnim = Tween(begin: -120.0, end: getScreenWidth(context) + 20).animate(
        CurvedAnimation(parent: _cloudController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _mountainController?.dispose();
    _carRotateController?.dispose();
    _carMoveController?.dispose();
    _cloudController?.dispose();

    super.dispose();
  }

  @override
  Widget buildView() {
    final width = getScreenWidth(context);

    return Container(
      height: fullHeight,
      child: AnimatedBuilder(
        animation: _mountainAnim,
        builder: (context, snapshot) {
          return AnimatedBuilder(
            animation: _carMoveAnim,
            builder: (context, child) {
              // 第一个风车移动距离
              final car1Len = width * 3 / 5 * _carMoveAnim.value;
              // 第二个风车移动距离
              final car2Len = width * 1 / 5 * _carMoveAnim.value;

              return Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  // 第二个风车
                  Positioned(
                    child: Container(
                      height: 80,
                      width: 40,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Positioned(
                            child: Image.asset(
                              "images/cloud_car1.png",
                              height: 40,
                            ),
                          ),
                          Positioned(
                            child: AnimatedBuilder(
                              animation: _carRotateAnim,
                              builder: (context, child) {
                                return Transform.rotate(
                                  alignment: Alignment.center,
                                  angle: _carRotateAnim.value,
                                  child: Image.asset(
                                    "images/cloud_car2.png",
                                    height: 44,
                                    width: 44,
                                  ),
                                );
                              },
                            ),
                            bottom: 18,
                          ),
                        ],
                      ),
                    ),
                    bottom: _getSinY(1 / 7 * width + (width - car2Len), width) *
                        _mountainAnim.value,
                    left: width - car2Len - 20,
                  ),

                  // 第二座山
                  CustomPaint(
                    size: Size(width, 120),
                    painter: _MountainPainter(_mountainAnim.value,
                        width * 1 / 7, const Color(0xFF6484A8)),
                  ),

                  // 第一个风车
                  Positioned(
                    child: Container(
                      height: 160,
                      width: 80,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Positioned(
                            child: Image.asset(
                              "images/cloud_car1.png",
                              height: 80,
                            ),
                          ),
                          Positioned(
                            child: AnimatedBuilder(
                              animation: _carRotateAnim,
                              builder: (context, child) {
                                return Transform.rotate(
                                  alignment: Alignment.center,
                                  angle: _carRotateAnim.value,
                                  child: Image.asset(
                                    "images/cloud_car2.png",
                                    height: 88,
                                    width: 88,
                                  ),
                                );
                              },
                            ),
                            bottom: 36,
                          ),
                        ],
                      ),
                    ),
                    bottom: _getSinY(6 / 7 * width + car1Len, width) *
                        _mountainAnim.value,
                    left: car1Len - 40,
                  ),

                  // 第一座山
                  CustomPaint(
                    size: Size(width, 120),
                    painter: _MountainPainter(_mountainAnim.value,
                        width * 6 / 7, const Color(0xFF59789D)),
                  ),

                  // 白云
                  AnimatedBuilder(
                    animation: _cloudAnim,
                    builder: (context, child) {
                      return Positioned(
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            "images/ic_cloud.png",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        bottom: 200,
                        left: _cloudAnim.value,
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
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
