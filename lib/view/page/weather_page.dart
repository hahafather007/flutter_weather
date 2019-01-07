import 'package:flutter_weather/commom_import.dart';

class WeatherPage extends StatefulWidget {
  final Function openDrawer;

  WeatherPage({@required this.openDrawer});

  @override
  State createState() => WeatherState(openDrawer: openDrawer);
}

class WeatherState extends PageState<WeatherPage> {
  final Function openDrawer;
  final _viewModel = WeatherViewModel();

  Timer _timer;

  WeatherState({@required this.openDrawer});

  @override
  void initState() {
    super.initState();

    debugPrint("init========>WeatherState");

    _viewModel.init();
    bindStreamOfViewModel(_viewModel);
//    DefaultAssetBundle.of(context)
//        .loadString("jsons/weather_map.json")
//        .then(debugPrint);
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    _timer?.cancel();

    super.dispose();
  }

  @override
  void networkError() {
    super.networkError();

    scafKey.currentState.removeCurrentSnackBar();
    scafKey.currentState.showSnackBar(SnackBar(
      content: Text(AppText.of(context).weatherGetFail),
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: AppText.of(context).retry,
        onPressed: () => _viewModel.loadData(isRefresh: false),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // 天气详情的高度
    final contentHeight = getScreenHeight(context) -
        getSysStatsHeight(context) -
        AppBar().preferredSize.height -
        110;

    return Scaffold(
      key: scafKey,
      appBar: CustomAppBar(
        title: StreamBuilder(
          stream: _viewModel.city.stream,
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? "",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            );
          },
        ),
        color: Colors.lightBlueAccent,
        showShadowLine: false,
        leftBtn: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: openDrawer,
        ),
        rightBtns: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.weather.stream,
          builder: (context, snapshot) {
            final Weather data = snapshot.data;

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: const ClampingScrollPhysics()),
                padding: const EdgeInsets.only(),
                children: <Widget>[
                  // 上半部分天气详情
                  Container(
                    height: contentHeight,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 56),
                    color: Colors.lightBlueAccent,
                    child: _buildContent(
                        now: data != null ? data.now : null,
                        daily: data != null ? data.dailyForecast.first : null),
                  ),

                  // 横向滚动显示每小时天气
//                  Container(
//                    height: 110,
//                    alignment: Alignment.centerLeft,
//                    child: ListView.builder(
//                      scrollDirection: Axis.horizontal,
//                      itemCount: data != null ? data.hourly.length : 0,
//                      itemBuilder: (ctx, index) {
//                        return _buildHourItem(hourly: data.hourly[index]);
//                      },
//                    ),
//                  ),

                  Divider(color: AppColor.colorLine),

                  // 每天天气情况显示
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 200,
                    child: Row(
                      children: data != null
                          ? data.dailyForecast
                              .map((v) => _buildDailyItem(daily: v))
                              .toList()
                          : const <Widget>[],
                    ),
                  ),

                  Divider(color: AppColor.colorLine),

                  // 中间显示pm2.5等情况的区域
                  StreamBuilder(
                    stream: _viewModel.air.stream,
                    builder: (context, snapshot) {
                      WeatherAir data = snapshot.data;

                      return Container(
                        height: 166,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildPm25Item(
                                    eName: "PM2.5",
                                    name: AppText.of(context).pm25,
                                    num: data != null
                                        ? data.airNowCity?.pm25 ?? "0"
                                        : "0",
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 18)),
                                  _buildPm25Item(
                                    eName: "SO2",
                                    name: AppText.of(context).so2,
                                    num: data != null
                                        ? data.airNowCity?.so2 ?? "0"
                                        : "0",
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 18)),
                                  _buildPm25Item(
                                    eName: "CO",
                                    name: AppText.of(context).co,
                                    num: data != null
                                        ? data.airNowCity?.co ?? "0"
                                        : "0",
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildPm25Item(
                                    eName: "PM10",
                                    name: AppText.of(context).pm10,
                                    num: data != null
                                        ? data.airNowCity?.pm10 ?? "0"
                                        : "0",
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 18)),
                                  _buildPm25Item(
                                    eName: "NO2",
                                    name: AppText.of(context).no2,
                                    num: data != null
                                        ? data.airNowCity?.no2 ?? "0"
                                        : "0",
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 18)),
                                  _buildPm25Item(
                                    eName: "O3",
                                    name: AppText.of(context).o3,
                                    num: data != null
                                        ? data.airNowCity?.o3 ?? "0"
                                        : "0",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  Divider(color: AppColor.colorLine),

                  // 最下面两排空气舒适度
                  // 第一排
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        _buildSoftItem(
                          url: "images/air_soft_1.png",
                          lifestyle: data != null && data.lifestyle != null
                              ? data.lifestyle[7]
                              : null,
                        ),
                        _buildSoftItem(
                          url: "images/air_soft_2.png",
                          lifestyle: data != null && data.lifestyle != null
                              ? data.lifestyle[0]
                              : null,
                        ),
                        _buildSoftItem(
                          url: "images/air_soft_3.png",
                          lifestyle: data != null && data.lifestyle != null
                              ? data.lifestyle[6]
                              : null,
                        ),
                        _buildSoftItem(
                          url: "images/air_soft_4.png",
                          lifestyle: data != null && data.lifestyle != null
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
                          lifestyle: data != null && data.lifestyle != null
                              ? data.lifestyle[2]
                              : null,
                        ),
                        _buildSoftItem(
                          url: "images/air_soft_6.png",
                          lifestyle: data != null && data.lifestyle != null
                              ? data.lifestyle[3]
                              : null,
                        ),
                        _buildSoftItem(
                          url: "images/air_soft_7.png",
                          lifestyle: data != null && data.lifestyle != null
                              ? data.lifestyle[4]
                              : null,
                        ),
                        _buildSoftItem(
                          url: "images/air_soft_8.png",
                          lifestyle: data != null && data.lifestyle != null
                              ? data.lifestyle[5]
                              : null,
                        ),
                      ],
                    ),
                  ),

                  // 最下面"数据来源说明"
                  Container(
                    color: AppColor.colorShadow,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Text(
                      AppText.of(context).dataSource,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.colorText2,
                      ),
                    ),
                  ),
                ],
              ),
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
              "${now != null ? now.tmp : 0}°",
              style: TextStyle(fontSize: 70, color: Colors.white),
            ),
            Padding(padding: const EdgeInsets.only(left: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${now != null ? now.condTxt : ""}",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 2),
                  child: Text(
                    "↑${daily != null ? daily.tmpMax : 0}℃",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                Text(
                  "↓${daily != null ? daily.tmpMin : 0}℃",
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
                  "${now != null ? now.hum : 0}％",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  AppText.of(context).hum,
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
                  "${now != null ? now.pres : 0}",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  AppText.of(context).pres,
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
                  "${now != null ? now.windSc : 0}${AppText.of(context).windSc}",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "${now != null ? now.windDir : ""}",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 每小时天气的Item
  Widget _buildHourItem({@required WeatherHourly hourly}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${hourly != null ? hourly.tmp : 0}°",
          style: TextStyle(
              fontSize: 14,
              color: AppColor.colorText2,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Image.asset(
            "images/${hourly != null ? hourly.condCode : 100}.png",
            height: 30,
            width: 30,
          ),
        ),
        Text(
          "${hourly != null ? hourly.time.substring(hourly.time.length - 5) : "00:00"}",
          style: TextStyle(
            color: AppColor.colorText2,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 每天天气的Item
  Widget _buildDailyItem({@required WeatherDailyForecast daily}) {
    final style = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _getWeekday(date: daily != null ? daily.date : ""),
            style: style,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Image.asset(
              "images/${daily != null ? daily.condCodeD : 100}.png",
              height: 30,
              width: 30,
            ),
          ),
          Text(
            "${daily != null ? daily.condTxtD : ""}",
            style: style,
          ),
        ],
      ),
    );
  }

  /// 根据日期返回星期几
  String _getWeekday({@required String date}) {
    final weekDate = DateTime.parse(date);

    switch (weekDate.weekday) {
      case DateTime.monday:
        return AppText.of(context).monday;
      case DateTime.tuesday:
        return AppText.of(context).tuesday;
      case DateTime.wednesday:
        return AppText.of(context).wednesday;
      case DateTime.thursday:
        return AppText.of(context).thursday;
      case DateTime.friday:
        return AppText.of(context).friday;
      case DateTime.saturday:
        return AppText.of(context).saturday;
      case DateTime.sunday:
        return AppText.of(context).sunday;
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
              "${lifestyle != null ? lifestyle.brf : ""}",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Text(
            _getSoftName(type: "${lifestyle != null ? lifestyle.type : ""}"),
            style: TextStyle(
              fontSize: 10,
              color: AppColor.colorText2,
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
        return AppText.of(context).air;
      case "cw":
        return AppText.of(context).cw;
      case "uv":
        return AppText.of(context).uv;
      case "trav":
        return AppText.of(context).trav;
      case "sport":
        return AppText.of(context).sport;
      case "drsg":
        return AppText.of(context).drsg;
      case "comf":
        return AppText.of(context).comf;
      case "flu":
        return AppText.of(context).flu;
    }

    return "";
  }

  /// 中间显示pm2.5的item
  /// [eName] 英文简称
  /// [name] 中文名
  /// [num] 数值
  Widget _buildPm25Item(
      {@required String eName, @required name, @required String num}) {
    final style = TextStyle(fontSize: 10, color: AppColor.colorText2);
    final numValue = double.parse(num);
    Color color;
    if (numValue <= 50) {
      color = Color(0xFF6BCD07);
    } else if (numValue <= 100) {
      color = Color(0xFFFBD029);
    } else if (numValue <= 150) {
      color = Color(0xFFFE8800);
    } else if (numValue <= 200) {
      color = Color(0xFFFE0000);
    } else if (numValue <= 300) {
      color = Color(0xFF970454);
    } else {
      color = Color(0xFF62001E);
    }
    return Container(
      margin: const EdgeInsets.only(right: 20),
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
                color: color,
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
                color: AppColor.colorText2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
