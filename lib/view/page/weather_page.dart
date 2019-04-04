import 'package:flutter_weather/commom_import.dart';

class WeatherPage extends StatefulWidget {
  @override
  State createState() => WeatherState();
}

class WeatherState extends PageState<WeatherPage> {
  final _viewModel = WeatherViewModel();

  Timer _timer;

  WeatherState();

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
    return StreamBuilder(
      stream: _viewModel.weatherType.stream,
      builder: (context, snapshot) {
        final type = snapshot.data ?? "";

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
                    fontSize: 20,
                  ),
                );
              },
            ),
            color: _getAppBarColor(type: type),
            showShadowLine: false,
            leftBtn: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => EventSendHolder()
                  .sendEvent(tag: "homeDrawerOpen", event: true),
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
                        child: Text("城市管理"),
                      ),
                      PopupMenuItem(
                        value: "weathers",
                        child: Text("动态天气预览"),
                      ),
                    ],
                onSelected: (value) {
                  switch (value) {
                    case "share":
                      break;
                    case "cities":
                      break;
                    case "weathers":
                      _showWeathersDialog();
                      break;
                  }
                },
              ),
            ],
          ),
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

                    return WeatherView(
                      type: type,
                      color: _getAppBarColor(type: type),
                      child: RefreshIndicator(
                        onRefresh: () => _viewModel.loadData(),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: const ClampingScrollPhysics()),
                          padding: const EdgeInsets.only(),
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
                                  daily: data?.dailyForecast?.first),
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

                                  Divider(color: AppColor.colorLine),

                                  // 每天天气情况显示
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    height: 200,
                                    child: Row(
                                      children: data != null
                                          ? data.dailyForecast
                                              .map((v) =>
                                                  _buildDailyItem(daily: v))
                                              .toList()
                                          : const [],
                                    ),
                                  ),

                                  Divider(color: AppColor.colorLine),

                                  // 中间显示pm2.5等情况的区域
                                  Container(
                                    height: 166,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              _buildPm25Item(
                                                eName: "PM2.5",
                                                name: AppText.of(context).pm25,
                                                num: air?.airNowCity?.pm25 ??
                                                    "0",
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 18)),
                                              _buildPm25Item(
                                                eName: "SO2",
                                                name: AppText.of(context).so2,
                                                num:
                                                    air?.airNowCity?.so2 ?? "0",
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 18)),
                                              _buildPm25Item(
                                                eName: "CO",
                                                name: AppText.of(context).co,
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
                                                name: AppText.of(context).pm10,
                                                num: air?.airNowCity?.pm10 ??
                                                    "0",
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 18)),
                                              _buildPm25Item(
                                                eName: "NO2",
                                                name: AppText.of(context).no2,
                                                num:
                                                    air?.airNowCity?.no2 ?? "0",
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 18)),
                                              _buildPm25Item(
                                                eName: "O3",
                                                name: AppText.of(context).o3,
                                                num: air?.airNowCity?.o3 ?? "0",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                                          lifestyle: data != null
                                              ? data.lifestyle[7]
                                              : null,
                                        ),
                                        _buildSoftItem(
                                          url: "images/air_soft_2.png",
                                          lifestyle: data != null
                                              ? data.lifestyle[0]
                                              : null,
                                        ),
                                        _buildSoftItem(
                                          url: "images/air_soft_3.png",
                                          lifestyle: data != null
                                              ? data.lifestyle[6]
                                              : null,
                                        ),
                                        _buildSoftItem(
                                          url: "images/air_soft_4.png",
                                          lifestyle: data != null
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
                                          lifestyle: data != null
                                              ? data.lifestyle[2]
                                              : null,
                                        ),
                                        _buildSoftItem(
                                          url: "images/air_soft_6.png",
                                          lifestyle: data != null
                                              ? data.lifestyle[3]
                                              : null,
                                        ),
                                        _buildSoftItem(
                                          url: "images/air_soft_7.png",
                                          lifestyle: data != null
                                              ? data.lifestyle[4]
                                              : null,
                                        ),
                                        _buildSoftItem(
                                          url: "images/air_soft_8.png",
                                          lifestyle: data != null
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
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 6),
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
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
                  "${now?.pres ?? 0}",
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
                  "${now?.windSc ?? 0}${AppText.of(context).windSc}",
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

  /// 每小时天气的Item
  Widget _buildHourItem({@required WeatherHourly hourly}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${hourly?.tmp ?? 0}°",
          style: TextStyle(
              fontSize: 14,
              color: AppColor.colorText2,
              fontWeight: FontWeight.bold),
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
            _getWeekday(date: daily?.date ?? ""),
            style: style,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Image.asset(
              "images/${daily?.condCodeD ?? 100}.png",
              height: 30,
              width: 30,
            ),
          ),
          Text(
            daily.condTxtD ?? "",
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
              lifestyle?.brf ?? "",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Text(
            _getSoftName(type: lifestyle?.type ?? ""),
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
    } else if (type.contains("沙")) {
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
              "动态天气预览",
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
                  _buildDialogItem(title: "晴"),
                  _buildDialogItem(title: "多云"),
                  _buildDialogItem(title: "阴"),
                  _buildDialogItem(title: "雨"),
                  _buildDialogItem(title: "雷雨"),
                  _buildDialogItem(title: "雨夹雪"),
                  _buildDialogItem(title: "雪"),
                  _buildDialogItem(title: "冰雹"),
                  _buildDialogItem(title: "雾"),
                  _buildDialogItem(title: "雾霾"),
                  _buildDialogItem(title: "沙尘暴"),
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
}
