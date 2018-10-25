import 'package:flutter_weather/commom_import.dart';

class WeatherPage extends StatefulWidget {
  final WeatherState _state = WeatherState();

  @override
  State createState() {
    debugPrint("========>WeatherPage");

    return _state;
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    _state.setDrawerOpenFunc(openDrawer: openDrawer);
  }
}

class WeatherState extends WeatherInter<WeatherPage> {
  WeatherPresenter _presenter;

  @override
  void initState() {
    super.initState();

    debugPrint("init========>WeatherState");

    _presenter = WeatherPresenter(this)..loadData();
    DefaultAssetBundle.of(context)
        .loadString("jsons/weather_map.json")
        .then(debugPrint);
  }

  @override
  void dispose() {
    super.dispose();

    _presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 天气详情的高度
    final contentHeight = getScreenHeight(context) -
        getSysStatsHeight(context) -
        AppBar().preferredSize.height -
        110;

    return Scaffold(
      appBar: CustomAppBar(
        title: _presenter.city,
        color: Colors.lightBlueAccent,
        showShadow: false,
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
        _presenter.isLoading,
        child: RefreshIndicator(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: false,
            enableOverScroll: false,
            child: ListView(
              padding: const EdgeInsets.only(),
              children: <Widget>[
                // 上半部分天气详情
                Container(
                  height: contentHeight,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 56),
                  color: Colors.lightBlueAccent,
                  child: _buildContent(),
                ),

                // 横向滚动显示每小时天气
                Container(
                  height: 110,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      if (index <= 8) {
                        return _buildHourItem();
                      }
                    },
                  ),
                ),

                Divider(color: AppColor.colorLine),

                // 每天天气情况显示
                Container(
                  margin: EdgeInsets.only(top: 8),
                  height: 200,
                  child: Row(
                    children: <Widget>[
                      _buildDailyItem(),
                      _buildDailyItem(),
                      _buildDailyItem(),
                      _buildDailyItem(),
                      _buildDailyItem(),
                      _buildDailyItem(),
                      _buildDailyItem(),
                    ],
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildPm25Item(
                              eName: "PM2.5",
                              name: "细颗粒物",
                              num: 52,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 18)),
                            _buildPm25Item(
                              eName: "SO2",
                              name: "二氧化硫",
                              num: 8,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 18)),
                            _buildPm25Item(
                              eName: "CO",
                              name: "一氧化碳",
                              num: 0.8,
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
                              name: "可吸入颗粒物",
                              num: 83,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 18)),
                            _buildPm25Item(
                              eName: "NO2",
                              name: "二氧化氮",
                              num: 41,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 18)),
                            _buildPm25Item(
                              eName: "O3",
                              name: "臭氧",
                              num: 23,
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
                        content: "良",
                        type: "空气",
                      ),
                      _buildSoftItem(
                        url: "images/air_soft_2.png",
                        content: "舒适",
                        type: "舒适度",
                      ),
                      _buildSoftItem(
                        url: "images/air_soft_3.png",
                        content: "不宜",
                        type: "洗车",
                      ),
                      _buildSoftItem(
                        url: "images/air_soft_4.png",
                        content: "较舒适",
                        type: "穿衣",
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
                        content: "易发",
                        type: "感冒",
                      ),
                      _buildSoftItem(
                        url: "images/air_soft_6.png",
                        content: "较不宜",
                        type: "运动",
                      ),
                      _buildSoftItem(
                        url: "images/air_soft_7.png",
                        content: "适宜",
                        type: "旅游",
                      ),
                      _buildSoftItem(
                        url: "images/air_soft_8.png",
                        content: "最弱",
                        type: "紫外线",
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
                      color: AppColor.colorText1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onRefresh: () => _presenter.refresh(),
        ),
      ),
    );
  }

  /// 最上面的天气详情
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // 上半部分
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "23°",
              style: TextStyle(fontSize: 70, color: Colors.white),
            ),
            Padding(padding: const EdgeInsets.only(left: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "多云",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 2),
                  child: Text(
                    "↑21℃",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                Text(
                  "↓13℃",
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
                  "48％",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "湿度",
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
                  "1019",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "气压",
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
                  "1级",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "东风",
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
  Widget _buildHourItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "17°",
          style: TextStyle(
              fontSize: 14,
              color: AppColor.colorText1,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Image.asset(
            "images/102.png",
            height: 30,
            width: 30,
          ),
        ),
        Text(
          "13:00",
          style: TextStyle(
            color: AppColor.colorText1,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 每天天气的Item
  Widget _buildDailyItem() {
    final style = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "星期三",
            style: style,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Image.asset(
              "images/303.png",
              height: 30,
              width: 30,
            ),
          ),
          Text(
            "小雨",
            style: style,
          ),
        ],
      ),
    );
  }

  /// 最下面空气舒适度Item
  /// [url] 图片的位置
  /// [type] 空气舒适度类别
  /// [content] 说明
  Widget _buildSoftItem(
      {@required String url, @required String content, @required String type}) {
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
              content,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black
              ),
            ),
          ),
          Text(
            type,
            style: TextStyle(
              fontSize: 10,
              color: AppColor.colorText1,
            ),
          ),
        ],
      ),
    );
  }

  /// 中间显示pm2.5的item
  /// [eName] 英文简称
  /// [name] 中文名
  /// [num] 数值
  Widget _buildPm25Item(
      {@required String eName, @required name, @required double num}) {
    final style = TextStyle(fontSize: 10, color: AppColor.colorText1);

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
                color: Colors.lightGreen,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            alignment: Alignment.bottomRight,
            child: Text(
              "${num < 1 ? num : num.toInt()}",
              style: TextStyle(
                fontSize: 16,
                color: AppColor.colorText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
