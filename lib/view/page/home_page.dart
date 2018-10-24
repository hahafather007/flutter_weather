import 'package:flutter_weather/commom_import.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends HomeInter<HomePage> {
  final _weatherPage = WeatherPage();
  final _girlPage = GiftPage();
  final _readPage = ReadPage();
  final _scafKey = GlobalObjectKey<ScaffoldState>("scafKey");

  /// 标识有效页面
  final _pageTypeMap = Map<PageType, bool>();

  /// 当前显示页面
  var _pageType = PageType.WEATHER;

  @override
  void initState() {
    super.initState();

    // 设置打开抽屉的回调，使子页面可以打开抽屉
    _weatherPage.setDrawerOpenFunc(openDrawer: () {
      _scafKey.currentState.openDrawer();
    });
    _girlPage.setDrawerOpenFunc(openDrawer: () {
      _scafKey.currentState.openDrawer();
    });
    _readPage.setDrawerOpenFunc(openDrawer: () {
      _scafKey.currentState.openDrawer();
    });

    // 让第一个页面生效
    _pageTypeMap[PageType.WEATHER] = true;
    _pageTypeMap[PageType.GIFT] = false;
    _pageTypeMap[PageType.READ] = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafKey,
      drawer: Drawer(
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.only(),
          children: <Widget>[
            NetImage(
                url:
                    "http://t2.hddhhn.com/uploads/tu/201610/198/scx30045vxd.jpg",
                height: 180,
                width: double.infinity),
            Padding(padding: const EdgeInsets.only(top: 8)),
            // 天气
            _buildDrawerItem(
                icon: Icons.cloud,
                title: AppText.of(context).weather,
                isTarget: _pageType == PageType.WEATHER,
                onTap: () {
                  if (_pageType == PageType.WEATHER) return;

                  setState(() {
                    _pageType = PageType.WEATHER;
                    _pageTypeMap[_pageType] = true;
                  });
                }),

            // 福利
            _buildDrawerItem(
                icon: Icons.card_giftcard,
                title: AppText.of(context).gift,
                isTarget: _pageType == PageType.GIFT,
                onTap: () {
                  if (_pageType == PageType.GIFT) return;

                  setState(() {
                    _pageType = PageType.GIFT;
                    _pageTypeMap[_pageType] = true;
                  });
                }),

            // 闲读
            _buildDrawerItem(
                icon: Icons.library_books,
                title: AppText.of(context).read,
                isTarget: _pageType == PageType.READ,
                onTap: () {
                  if (_pageType == PageType.READ) return;

                  setState(() {
                    _pageType = PageType.READ;
                    _pageTypeMap[_pageType] = true;
                  });
                }),

            // 分割线
            Divider(),

            // 设置
            _buildDrawerItem(
                icon: Icons.settings,
                title: AppText.of(context).setting,
                isTarget: false,
                onTap: () => push(context, page: SettingPage())),

            // 关于
            _buildDrawerItem(
                icon: Icons.error_outline,
                title: AppText.of(context).about,
                isTarget: false,
                onTap: () => push(context, page: AboutPage())),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  /// 根据[_pageType]加载不同界面
  /// 利用[Offstage]和[TickerMode]配合实现懒加载
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        // 天气页面
        Offstage(
          offstage: _pageType != PageType.WEATHER,
          child: TickerMode(
            enabled: _pageType == PageType.WEATHER,
            child: _pageTypeMap[PageType.WEATHER] ? _weatherPage : Container(),
          ),
        ),

        // 福利页面
        Offstage(
          offstage: _pageType != PageType.GIFT,
          child: TickerMode(
            enabled: _pageType == PageType.GIFT,
            child: _pageTypeMap[PageType.GIFT] ? _girlPage : Container(),
          ),
        ),

        // 闲读页面
        Offstage(
          offstage: _pageType != PageType.READ,
          child: TickerMode(
            enabled: _pageType == PageType.READ,
            child: _pageTypeMap[PageType.READ] ? _readPage : Container(),
          ),
        ),
      ],
    );
  }

  /// drawer的每个可点击选项
  Widget _buildDrawerItem(
      {@required IconData icon,
      @required String title,
      @required bool isTarget,
      @required Function onTap}) {
    return Material(
      child: InkWell(
        onTap: () {
          // 点击后关闭抽屉
          pop(context);

          onTap();
        },
        child: Container(
          color: isTarget ? AppColor.colorShadow : Colors.transparent,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: isTarget ? AppColor.colorMain : AppColor.colorText1,
              ),
              Container(
                margin: const EdgeInsets.only(left: 26),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isTarget ? AppColor.colorMain : AppColor.colorText1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PageType {
  /// 天气页面
  WEATHER,

  /// 福利页面
  GIFT,

  /// 闲读页面
  READ,
}
