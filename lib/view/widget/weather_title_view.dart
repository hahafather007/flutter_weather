import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/utils/system_util.dart';

/// 天气界面的滚动标题
class WeatherTitleView extends StatefulWidget {
  final List<String> cities;
  final double pageValue;

  WeatherTitleView({@required this.cities, @required this.pageValue});

  @override
  State createState() {
    return _WeatherTitleState();
  }
}

class _WeatherTitleState extends State<WeatherTitleView> {
  final _paddingLeft = StreamController<double>();
  final _titleKeys = List<GlobalKey>();
  final _titleWidth = List<double>();

  Timer _timer;
  double _currentPadding = 0;

  @override
  void initState() {
    super.initState();

    _calculateWidth();
  }

  @override
  void dispose() {
    _titleWidth.clear();
    _titleKeys.clear();
    _timer?.cancel();
    _paddingLeft.close();

    super.dispose();
  }

  @override
  void didUpdateWidget(WeatherTitleView oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool isCityChange = widget.cities.length != oldWidget.cities.length;
    if (!isCityChange) {
      List.generate(widget.cities.length, (index) {
        isCityChange = widget.cities[index] != oldWidget.cities[index];
      });
    }

    if (isCityChange) {
      _calculateWidth();
    } else if (_titleWidth.isNotEmpty) {
      if (widget.pageValue == widget.pageValue.toInt()) {
        _calculateWidth();
      } else {
        // 往右滑动
        if (widget.pageValue > oldWidget.pageValue) {
          int target = 0;
          target = widget.pageValue.toInt() + 1;
          final move = _titleWidth[target - 1] +
              (_titleWidth[target] - _titleWidth[target - 1]) / 2;
          _currentPadding -= move * (widget.pageValue - oldWidget.pageValue);
          streamAdd(_paddingLeft, _currentPadding);
        }
        // 往左滑动
        else if (widget.pageValue < oldWidget.pageValue) {
          int target = widget.pageValue.toInt();
          final move = _titleWidth[target] +
              (_titleWidth[target + 1] - _titleWidth[target]) / 2;
          _currentPadding += move * (oldWidget.pageValue - widget.pageValue);
          streamAdd(_paddingLeft, _currentPadding);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cities = widget.cities;
    final pageValue = widget.pageValue;

    return Container(
      padding: EdgeInsets.only(top: getStatusHeight(context)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 当前城市
          Container(
            height: 28,
            child: Stack(
              children: <Widget>[
                StreamBuilder(
                  stream: _paddingLeft.stream,
                  initialData: _currentPadding,
                  builder: (context, snapshot) {
                    final left = getScreenWidth(context) / 2 + snapshot.data;

                    return Positioned(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(cities.length, (index) {
                          final value = 1 - (pageValue - index).abs();

                          return Opacity(
                            opacity: value >= 0 &&
                                    value <= 1 &&
                                    _titleWidth.length == _titleKeys.length
                                ? value
                                : 0,
                            child: Text(
                              "${cities[index]}",
                              key: _titleKeys[index],
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          );
                        }),
                      ),
                      left: left,
                    );
                  },
                ),
              ],
            ),
          ),

          // 指示的小点
          cities.length > 1
              ? Stack(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: cities.map((city) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white54),
                          width: 5,
                          height: 5,
                        );
                      }).toList(),
                    ),
                    Positioned(
                      left: 11 * pageValue,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        width: 5,
                        height: 5,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  /// 计算每个标题宽度
  void _calculateWidth() {
    _titleKeys.clear();
    _titleKeys.addAll(widget.cities.map((_) => GlobalKey()));
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 50), () {
      _titleWidth.clear();
      _titleWidth.addAll(_titleKeys.map((v) => v.currentContext.size.width));
      _initPadding();
    });
  }

  /// 计算左边距
  void _initPadding() {
    if (_titleWidth.isEmpty) return;

    double padding = 0;
    int i = 0;

    for (i = 0; i < widget.pageValue; i++) {
      padding -= _titleWidth[i];
    }
    padding -= _titleWidth[widget.pageValue.toInt()] *
        (1 - (widget.pageValue - i).abs()) /
        2;
    _currentPadding = padding;
    streamAdd(_paddingLeft, padding);
  }
}
