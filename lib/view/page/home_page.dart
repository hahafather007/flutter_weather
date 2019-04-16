import 'package:flutter_weather/commom_import.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends PageState<HomePage> {
  /// 标识有效页面
  final _pageTypeMap = Map<PageType, bool>();

  /// 当前显示页面
  var _pageType = PageType.WEATHER;

  bool _readyExit = false;
  Timer _exitTimer;

  @override
  void initState() {
    super.initState();

    ToastUtil.initToast(context);

    bindSub(EventSendHolder()
        .event
        .where((pair) => pair.a == "homeDrawerOpen")
        .listen((pair) {
      if (pair.b) {
        scafKey.currentState.openDrawer();
      } else {
        pop(context);
      }
    }));

    // 让第一个页面生效
    _pageTypeMap[PageType.WEATHER] = true;
    _pageTypeMap[PageType.GIFT] = false;
    _pageTypeMap[PageType.READ] = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final pageModules = SharedDepository().pageModules;
    pageModules.forEach((module) {
      switch (module.module) {
        case "weather":
          if (!module.open) {
            _pageTypeMap[PageType.WEATHER] = false;
          }
          break;
        case "read":
          if (!module.open) {
            _pageTypeMap[PageType.READ] = false;
          }
          break;
        case "gift":
          if (!module.open) {
            _pageTypeMap[PageType.GIFT] = false;
          }
          break;
      }
    });
    if (!_pageTypeMap.values.contains(true)) {
      final index = pageModules.indexWhere((v) => v.open);
      if (index != -1) {
        switch (pageModules[index].module) {
          case "weather":
            _pageTypeMap[PageType.WEATHER] = true;
            _pageType = PageType.WEATHER;
            break;
          case "read":
            _pageTypeMap[PageType.READ] = true;
            _pageType = PageType.READ;
            break;
          case "gift":
            _pageTypeMap[PageType.GIFT] = true;
            _pageType = PageType.GIFT;
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    ToastUtil.disposeToast();
    FavHolder().dispose();
    _exitTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageModules = SharedDepository().pageModules;

    return WillPopScope(
      child: Scaffold(
        key: scafKey,
        drawer: Drawer(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: const ClampingScrollPhysics()),
            padding: const EdgeInsets.only(),
            children: <Widget>[
              // 顶部图片
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Image.asset("images/drawer_bg.png"),
              ),

              // 主要页面选项
              Column(
                children: pageModules.map((module) {
                  switch (module.module) {
                    // 天气
                    case "weather":
                      return module.open
                          ? _buildDrawerItem(
                              icon: Icons.wb_sunny,
                              title: AppText.of(context).weather,
                              isTarget: _pageType == PageType.WEATHER,
                              onTap: () {
                                if (_pageType == PageType.WEATHER) return;

                                setState(() {
                                  _pageType = PageType.WEATHER;
                                  _pageTypeMap[_pageType] = true;
                                });
                              })
                          : Container();

                    // 福利
                    case "gift":
                      return module.open
                          ? _buildDrawerItem(
                              icon: Icons.card_giftcard,
                              title: AppText.of(context).gift,
                              isTarget: _pageType == PageType.GIFT,
                              onTap: () {
                                if (_pageType == PageType.GIFT) return;

                                setState(() {
                                  _pageType = PageType.GIFT;
                                  _pageTypeMap[_pageType] = true;
                                });
                              })
                          : Container();

                    // 闲读
                    case "read":
                      return module.open
                          ? _buildDrawerItem(
                              icon: Icons.local_cafe,
                              title: AppText.of(context).read,
                              isTarget: _pageType == PageType.READ,
                              onTap: () {
                                if (_pageType == PageType.READ) return;

                                setState(() {
                                  _pageType = PageType.READ;
                                  _pageTypeMap[_pageType] = true;
                                });
                              })
                          : Container();
                  }
                }).toList(),
              ),

              // 分割线
              Divider(color: AppColor.colorLine),

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
      ),
      onWillPop: () {
        if (_readyExit) {
          exitApp();
        } else {
          _readyExit = true;
          _exitTimer =
              Timer(const Duration(seconds: 2), () => _readyExit = false);
          scafKey.currentState.showSnackBar(SnackBar(
            content: Text("再按一次退出App！"),
            duration: const Duration(seconds: 2),
          ));
        }
      },
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
            child: _pageTypeMap[PageType.WEATHER] ? WeatherPage() : Container(),
          ),
        ),

        // 福利页面
        Offstage(
          offstage: _pageType != PageType.GIFT,
          child: TickerMode(
            enabled: _pageType == PageType.GIFT,
            child: _pageTypeMap[PageType.GIFT] ? GiftPage() : Container(),
          ),
        ),

        // 闲读页面
        Offstage(
          offstage: _pageType != PageType.READ,
          child: TickerMode(
            enabled: _pageType == PageType.READ,
            child: _pageTypeMap[PageType.READ] ? ReadPage() : Container(),
          ),
        ),

        // 关闭所有页面时的占位图片
        Center(
          child: SharedDepository().pageModules.indexWhere((v) => v.open) == -1
              ? Image.asset("images/nothing_here.gif")
              : Container(),
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
                color: isTarget
                    ? Theme.of(context).accentColor
                    : AppColor.colorText2,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isTarget ? Theme.of(context).accentColor : Colors.black,
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
