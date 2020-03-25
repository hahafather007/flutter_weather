import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/weather_air_data.dart';
import 'package:flutter_weather/model/data/weather_data.dart';
import 'package:flutter_weather/utils/aqi_util.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/circle_air_view.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/viewmodel/weather_city_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherCityPage extends StatefulWidget {
  final int index;
  final Function(double) onScroll;

  WeatherCityPage({Key key, @required this.index, @required this.onScroll})
      : super(key: key);

  @override
  State createState() => WeatherCityState();
}

class WeatherCityState extends PageState<WeatherCityPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _airKey = GlobalKey<CircleAirState>();

  WeatherCityViewModel _viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _viewModel = WeatherCityViewModel(index: widget.index);
    _scrollController.addListener(() {
      widget.onScroll(_scrollController.offset);
      if (_scrollController.offset >= 320) {
        _airKey.currentState.startAnim();
      }
    });
    _viewModel.perStatus.stream
        .where((status) => status == PermissionStatus.denied)
        .listen((_) => showSnack(
            text: S.of(context).locationError,
            duration: const Duration(hours: 1),
            action: SnackBarAction(
                label: S.of(context).setting,
                onPressed: () => PermissionHandler().openAppSettings())))
        .bindLife(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bindErrorStream(_viewModel.error.stream,
        errorText: S.of(context).weatherFail,
        retry: () => _viewModel.loadData(isRefresh: false));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      key: scafKey,
      backgroundColor: Colors.transparent,
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.weather.stream,
          builder: (context, snapshot) {
            final Weather data = snapshot.data;

            return StreamBuilder(
              stream: _viewModel.air.stream,
              builder: (context, snapshot) {
                final WeatherAir air = snapshot.data;

                return RefreshIndicator(
                  onRefresh: () => _viewModel.loadData(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: const ClampingScrollPhysics()),
                    padding: const EdgeInsets.only(),
                    controller: _scrollController,
                    children: <Widget>[
                      // 上半部分天气详情
                      Container(
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        height: getScreenHeight(context) -
                            getStatusHeight(context) -
                            getAppBarHeight() -
                            110,
                        padding: const EdgeInsets.only(top: 60),
                        child: _buildContent(
                          now: data?.now,
                          daily: data?.dailyForecast?.first,
                        ),
                      ),

                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            // 横向滚动显示每小时天气
                            Container(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data?.hourly?.length ?? 0,
                                padding: const EdgeInsets.only(),
                                itemBuilder: (context, index) {
                                  return _buildHourItem(
                                      hourly: data.hourly[index]);
                                },
                              ),
                            ),

                            Divider(color: AppColor.line),

                            // 一周天气预测
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 240,
                              child: _buildWeekWeather(data: data),
                            ),

                            Divider(color: AppColor.line),

                            // 中间显示pm2.5等情况的区域
                            Container(
                              height: 166,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: CircleAirView(
                                        key: _airKey,
                                        aqi: double.parse(
                                            air?.airNowCity?.aqi ?? "0"),
                                        qlty: air?.airNowCity?.qlty ?? "",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _buildPm25Item(
                                          eName: "PM2.5",
                                          name: S.of(context).pm25,
                                          num: air?.airNowCity?.pm25 ?? "0",
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 18)),
                                        _buildPm25Item(
                                          eName: "SO2",
                                          name: S.of(context).so2,
                                          num: air?.airNowCity?.so2 ?? "0",
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 18)),
                                        _buildPm25Item(
                                          eName: "CO",
                                          name: S.of(context).co,
                                          num: air?.airNowCity?.co ?? "0",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _buildPm25Item(
                                          eName: "PM10",
                                          name: S.of(context).pm10,
                                          num: air?.airNowCity?.pm10 ?? "0",
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 18)),
                                        _buildPm25Item(
                                          eName: "NO2",
                                          name: S.of(context).no2,
                                          num: air?.airNowCity?.no2 ?? "0",
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 18)),
                                        _buildPm25Item(
                                          eName: "O3",
                                          name: S.of(context).o3,
                                          num: air?.airNowCity?.o3 ?? "0",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Divider(color: AppColor.line),

                            // 最下面两排空气舒适度
                            // 第一排
                            Container(
                              height: 100,
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  _buildSoftItem(
                                    url: "images/air_soft_1.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[7]
                                        : null,
                                  ),
                                  _buildSoftItem(
                                    url: "images/air_soft_2.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[0]
                                        : null,
                                  ),
                                  _buildSoftItem(
                                    url: "images/air_soft_3.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[6]
                                        : null,
                                  ),
                                  _buildSoftItem(
                                    url: "images/air_soft_4.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[1]
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            // 第二排
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              height: 100,
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  _buildSoftItem(
                                    url: "images/air_soft_5.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[2]
                                        : null,
                                  ),
                                  _buildSoftItem(
                                    url: "images/air_soft_6.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[3]
                                        : null,
                                  ),
                                  _buildSoftItem(
                                    url: "images/air_soft_7.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[4]
                                        : null,
                                  ),
                                  _buildSoftItem(
                                    url: "images/air_soft_8.png",
                                    lifestyle: data?.lifestyle != null
                                        ? data.lifestyle[5]
                                        : null,
                                  ),
                                ],
                              ),
                            ),

                            // 最下面"数据来源说明"
                            Container(
                              color: AppColor.shadow,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 6, bottom: 6),
                              child: Text(
                                S.of(context).dataSource,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.text2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// 最上面的天气详情
  Widget _buildContent(
      {@required WeatherNow now, @required WeatherDailyForecast daily}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // 上半部分
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${now?.tmp ?? 0}°",
              style: TextStyle(fontSize: 70, color: Colors.white),
            ),
            Padding(padding: const EdgeInsets.only(left: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  now?.condTxt ?? "",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 2),
                  child: Text(
                    "↑${daily?.tmpMax ?? 0}℃",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                Text(
                  "↓${daily?.tmpMin ?? 0}℃",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                )
              ],
            ),
          ],
        ),

        Padding(padding: const EdgeInsets.only(top: 6)),

        // 下半部分
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${now?.hum ?? 0}％",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  S.of(context).hum,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              width: 1,
              height: 25,
              color: Colors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${now?.pres ?? 0}",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  S.of(context).pres,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              width: 1,
              height: 25,
              color: Colors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${now?.windSc ?? 0}${S.of(context).windSc}",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  now?.windDir ?? "",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 一周天气预测
  Widget _buildWeekWeather({@required Weather data}) {
    final style = TextStyle(color: Colors.black, fontSize: 10);

    // 整体最高温度
    int maxTemp = -100;
    // 整体最低温度
    int minTemp = 100;

    data?.dailyForecast?.forEach((daily) {
      final max = int.parse("${daily?.tmpMax ?? -100}");
      final min = int.parse("${daily?.tmpMin ?? 100}");
      if (max > maxTemp) {
        maxTemp = max;
      }
      if (min < minTemp) {
        minTemp = min;
      }
    });

    return Row(
      children: data?.dailyForecast != null
          ? data.dailyForecast.map((daily) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // 星期
                    Text(
                      _getWeekday(date: daily?.date ?? ""),
                      style: style,
                    ),

                    // 天气图片
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Image.asset(
                        "images/${daily?.condCodeD ?? 100}.png",
                        height: 30,
                        width: 30,
                      ),
                    ),

                    // 天气文字
                    Text(
                      daily?.condTxtD ?? "",
                      style: style,
                    ),

                    // 温度
                    Expanded(
                      child: daily?.tmpMin != null && daily?.tmpMax != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(),
                                  flex:
                                      (maxTemp - int.parse(daily.tmpMax)).abs(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 2),
                                  child: Text(
                                    "${daily.tmpMax}℃",
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 10),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 8,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffdde1e2),
                                        borderRadius: BorderRadius.circular(3)),
                                  ),
                                  flex: int.parse(daily.tmpMax) -
                                      int.parse(daily.tmpMin),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, bottom: 8),
                                  child: Text(
                                    "${daily.tmpMin}℃",
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 10),
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                  flex:
                                      (minTemp - int.parse(daily.tmpMin)).abs(),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ],
                ),
              );
            }).toList()
          : const [],
    );
  }

  /// 每小时天气的Item
  Widget _buildHourItem({@required WeatherHourly hourly}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${hourly?.tmp ?? 0}°",
          style: TextStyle(
              fontSize: 14, color: AppColor.text2, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Image.asset(
            "images/${hourly?.condCode ?? 100}.png",
            height: 30,
            width: 30,
          ),
        ),
        Text(
          hourly?.time?.substring(hourly.time.length - 5) ?? "00:00",
          style: TextStyle(
            color: AppColor.text2,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 根据日期返回星期几
  String _getWeekday({@required String date}) {
    final weekDate = DateTime.parse(date);

    if (weekDate.day == DateTime.now().day) {
      return S.of(context).today;
    }

    switch (weekDate.weekday) {
      case DateTime.monday:
        return S.of(context).monday;
      case DateTime.tuesday:
        return S.of(context).tuesday;
      case DateTime.wednesday:
        return S.of(context).wednesday;
      case DateTime.thursday:
        return S.of(context).thursday;
      case DateTime.friday:
        return S.of(context).friday;
      case DateTime.saturday:
        return S.of(context).saturday;
      case DateTime.sunday:
        return S.of(context).sunday;
    }

    return "";
  }

  /// 最下面空气舒适度Item
  /// [url] 图片的位置
  Widget _buildSoftItem(
      {@required String url, @required WeatherLifestyle lifestyle}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            url,
            height: 40,
            width: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 1),
            child: Text(
              lifestyle?.brf ?? "",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Text(
            _getSoftName(type: lifestyle?.type ?? ""),
            style: TextStyle(
              fontSize: 10,
              color: AppColor.text2,
            ),
          ),
        ],
      ),
    );
  }

  /// 根据[type] 返回舒适度的名称
  String _getSoftName({@required String type}) {
    switch (type) {
      case "air":
        return S.of(context).air;
      case "cw":
        return S.of(context).cw;
      case "uv":
        return S.of(context).uv;
      case "trav":
        return S.of(context).trav;
      case "sport":
        return S.of(context).sport;
      case "drsg":
        return S.of(context).drsg;
      case "comf":
        return S.of(context).comf;
      case "flu":
        return S.of(context).flu;
    }

    return "";
  }

  /// 中间显示pm2.5的item
  /// [eName] 英文简称
  /// [name] 中文名
  /// [num] 数值
  Widget _buildPm25Item(
      {@required String eName, @required name, @required String num}) {
    final style = TextStyle(fontSize: 10, color: AppColor.text2);
    final numValue = double.parse(num);

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eName,
                style: style,
              ),
              Text(
                name,
                style: style,
              ),
              Container(
                margin: const EdgeInsets.only(top: 3),
                height: 2,
                color: AqiUtil.getAqiColor(numValue),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            alignment: Alignment.bottomRight,
            child: Text(
              num,
              style: TextStyle(
                fontSize: 16,
                color: AppColor.text2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
