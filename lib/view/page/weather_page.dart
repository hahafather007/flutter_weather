import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather/language.dart';
import 'package:flutter_weather/model/data/mixing.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/city_control_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/weather_city_page.dart';
import 'package:flutter_weather/view/weather/weather_view.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';
import 'package:flutter_weather/view/widget/weather_title_view.dart';
import 'package:flutter_weather/viewmodel/weather_viewmodel.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({Key key}) : super(key: key);

  @override
  State createState() => WeatherState();
}

class WeatherState extends PageState<WeatherPage> {
  final _viewModel = WeatherViewModel();
  final _controller = PageController();
  final _titleController = PageController();
  final _pageStream = StreamController<double>();
  final _titleAlpha = StreamController<double>();

  double _titleAlphaValue = 0;

  @override
  bool get bindLife => true;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      _pageStream.safeAdd(_controller.page);
    });
  }

  @override
  void onPause() {
    super.onPause();

    _viewModel.changeHideState(true);
  }

  @override
  void onResume() {
    super.onResume();

    _viewModel.changeHideState(false);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _controller.dispose();
    _titleController.dispose();
    _pageStream.close();
    _titleAlpha.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _viewModel.weather.stream,
      builder: (context, snapshot) {
        final Pair<Weather, AirNowCity> pair = snapshot.data;
        final type = pair?.a?.now?.condTxt ?? "";

        return StreamBuilder(
          stream: _viewModel.cities.stream,
          builder: (context, snapshot) {
            final List<String> cities = snapshot.data ?? [];

            return StreamBuilder(
              stream: _pageStream.stream,
              builder: (context, snapshot) {
                final double pageValue = snapshot.data ?? 0;
                final location = cities.isNotEmpty
                    ? cities[min(cities.length - 1, pageValue.round())]
                    : "";

                return Scaffold(
                  key: scafKey,
                  appBar: PreferredSize(
                    child: AnimatedContainer(
                      color: _getAppBarColor(type: type),
                      duration: const Duration(seconds: 2),
                      child: StreamBuilder(
                        stream: _titleAlpha.stream,
                        initialData: 0.0,
                        builder: (context, snapshot) {
                          final alpha = snapshot.data;

                          return Stack(
                            children: <Widget>[
                              // 指示条
                              Opacity(
                                opacity: 1 - alpha,
                                child: WeatherTitleView(
                                  cities: cities,
                                  pageValue: pageValue,
                                ),
                              ),

                              // 标题栏
                              CustomAppBar(
                                title: Text(
                                  location,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(alpha),
                                    fontSize: 20,
                                  ),
                                ),
                                color: Colors.transparent,
                                showShadow: false,
                                leftBtn: IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => EventSendHolder().sendEvent(
                                      tag: "homeDrawerOpen", event: true),
                                ),
                                rightBtns: [
                                  PopupMenuButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: "share",
                                        child: Text(AppText.of(context).share),
                                      ),
                                      PopupMenuItem(
                                        value: "cities",
                                        child: Text(
                                            AppText.of(context).cityControl),
                                      ),
                                      PopupMenuItem(
                                        value: "weathers",
                                        child: Text(
                                            AppText.of(context).weathersView),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      switch (value) {
                                        case "share":
                                          if (pair?.a == null ||
                                              pair?.b == null) return;
                                          break;
                                        case "cities":
                                          push(context,
                                              page: CityControlPage());
                                          break;
                                        case "weathers":
                                          _showWeathersDialog();
                                          break;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    preferredSize: Size.fromHeight(getAppBarHeight()),
                  ),
                  body: StreamBuilder(
                    stream: _viewModel.hideWeather.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      final hideWeather = snapshot.data;

                      return WeatherView(
                        type: type,
                        color: _getAppBarColor(type: type),
                        hide: hideWeather,
                        child: PageView.builder(
                          itemCount: cities.length,
                          controller: _controller,
                          physics: const ClampingScrollPhysics(),
                          onPageChanged: (index) =>
                              _viewModel.indexChange(index),
                          itemBuilder: (context, index) {
                            final value = 1 - (pageValue - index).abs();

                            return Opacity(
                              opacity: value >= 0 && value <= 1 ? value : 0,
                              child: WeatherCityPage(
                                key: Key("WeatherCityPage${cities[index]}"),
                                index: index,
                                onScroll: (offset) {
                                  final height = getStatusHeight(context) +
                                      getAppBarHeight();
                                  if (offset <= height) {
                                    _titleAlphaValue = offset / height;
                                    _titleAlpha.safeAdd(_titleAlphaValue);
                                  } else {
                                    if (_titleAlphaValue == 1) return;

                                    _titleAlphaValue = 1;
                                    _titleAlpha.safeAdd(_titleAlphaValue);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// 获取Appbar的颜色
  Color _getAppBarColor({@required String type}) {
    final isDay = DateTime.now().hour >= 6 && DateTime.now().hour < 18;

    if (type.contains("晴") || type.contains("多云")) {
      return isDay ? const Color(0xFF51C0F8) : const Color(0xFF7F9EE9);
    } else if (type.contains("雨")) {
      if (type.contains("雪")) {
        return const Color(0XFF5697D8);
      } else {
        return const Color(0xFF7187DB);
      }
    } else if (type.contains("雪")) {
      return const Color(0xFF62B1FF);
    } else if (type.contains("冰雹")) {
      return const Color(0xFF0CB399);
    } else if (type.contains("霾")) {
      return const Color(0xFF7F8195);
    } else if (type.contains("沙") || type.contains("尘")) {
      return const Color(0xFFE99E3C);
    } else if (type.contains("雾")) {
      return const Color(0xFF8CADD3);
    } else if (type.contains("阴")) {
      return const Color(0xFF6D8DB1);
    } else {
      return isDay ? const Color(0xFF51C0F8) : const Color(0xFF7F9EE9);
    }
  }

  /// 动态天气预览弹窗
  void _showWeathersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppText.of(context).weathersView,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        contentPadding: const EdgeInsets.only(),
        titlePadding: const EdgeInsets.fromLTRB(20, 18, 0, 10),
        content: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(),
            children: <Widget>[
              _buildDialogItem(title: AppText.of(context).sunny),
              _buildDialogItem(title: AppText.of(context).cloudy),
              _buildDialogItem(title: AppText.of(context).overcast),
              _buildDialogItem(title: AppText.of(context).rain),
              _buildDialogItem(title: AppText.of(context).flashRain),
              _buildDialogItem(title: AppText.of(context).snowRain),
              _buildDialogItem(title: AppText.of(context).snow),
              _buildDialogItem(title: AppText.of(context).hail),
              _buildDialogItem(title: AppText.of(context).fog),
              _buildDialogItem(title: AppText.of(context).smog),
              _buildDialogItem(title: AppText.of(context).sandstorm),
            ],
          ),
        ),
      ),
    );
  }

  /// 动态天气预览的选项
  Widget _buildDialogItem({@required String title}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          pop(context);
          _viewModel.switchType(title);
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Icon(
                  Icons.panorama_fish_eye,
                  color: Colors.black54,
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 改变天气动画显示状态
  void changeHideState(bool hide) {
    _viewModel.changeHideState(hide);
  }
}
