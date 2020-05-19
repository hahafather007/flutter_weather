import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/holder/app_version_holder.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/about_page.dart';
import 'package:flutter_weather/view/page/fav_page.dart';
import 'package:flutter_weather/view/page/ganhuo_page.dart';
import 'package:flutter_weather/view/page/gift_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/read_page.dart';
import 'package:flutter_weather/view/page/setting_page.dart';
import 'package:flutter_weather/view/page/weather_page.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends PageState<HomePage> {
  /// 标识有效页面
  final _pageTypeMap = Map<PageType, bool>();
  final _weatherKey = GlobalKey<WeatherState>();

  /// 当前显示页面
  PageType _pageType = PageType.WEATHER;
  bool _readyExit = false;
  Timer _exitTimer;

  @override
  void initState() {
    super.initState();

    AppVersionHolder().checkUpdate(context);

    EventSendHolder()
        .event
        .where((pair) => pair.a == "homeDrawerOpen")
        .listen((pair) {
      if (pair.b) {
        scafKey.currentState.openDrawer();
      } else {
        pop(context);
      }
    }).bindLife(this);

    // 首次进入清除缓存
    if (SharedDepository().shouldClean) {
      DefaultCacheManager().emptyCache();
      SharedDepository().setsShouldClean(false);
    }

    // 让第一个页面生效
    _pageTypeMap[PageType.WEATHER] = true;
    _pageTypeMap[PageType.GIFT] = false;
    _pageTypeMap[PageType.READ] = false;
    _pageTypeMap[PageType.GANHUO] = false;
    _pageTypeMap[PageType.COLLECT] = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// 关闭掉不会再出现的页面
    SharedDepository().pageModules.forEach((module) {
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
        case "ganhuo":
          if (!module.open) {
            _pageTypeMap[PageType.GANHUO] = false;
          }
          break;
        case "gift":
          if (!module.open) {
            _pageTypeMap[PageType.GIFT] = false;
          }
          break;
        case "collect":
          if (!module.open) {
            _pageTypeMap[PageType.COLLECT] = false;
          }
          break;
      }
    });
  }

  @override
  void dispose() {
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
                children:
                    pageModules.where((module) => module.open).map((module) {
                  switch (module.module) {
                    // 天气
                    case "weather":
                      return _buildDrawerItem(
                          icon: Icons.wb_sunny,
                          title: S.of(context).weather,
                          isTarget: _pageType == PageType.WEATHER,
                          onTap: () {
                            if (_pageType == PageType.WEATHER) return;

                            _weatherKey.currentState?.changeHideState(false);
                            setState(() {
                              _pageType = PageType.WEATHER;
                              _pageTypeMap[_pageType] = true;
                            });
                          });

                    // 福利
                    case "gift":
                      return _buildDrawerItem(
                          icon: Icons.card_giftcard,
                          title: S.of(context).gift,
                          isTarget: _pageType == PageType.GIFT,
                          onTap: () {
                            if (_pageType == PageType.GIFT) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _pageType = PageType.GIFT;
                              _pageTypeMap[_pageType] = true;
                            });
                          });

                    // 闲读
                    case "read":
                      return _buildDrawerItem(
                          icon: Icons.local_cafe,
                          title: S.of(context).read,
                          isTarget: _pageType == PageType.READ,
                          onTap: () {
                            if (_pageType == PageType.READ) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _pageType = PageType.READ;
                              _pageTypeMap[_pageType] = true;
                            });
                          });

                    // 闲读
                    case "ganhuo":
                      return _buildDrawerItem(
                          icon: Icons.android,
                          title: S.of(context).ganHuo,
                          isTarget: _pageType == PageType.GANHUO,
                          onTap: () {
                            if (_pageType == PageType.GANHUO) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _pageType = PageType.GANHUO;
                              _pageTypeMap[_pageType] = true;
                            });
                          });

                    // 闲读
                    case "collect":
                      return _buildDrawerItem(
                          icon: Icons.favorite_border,
                          title: S.of(context).collect,
                          isTarget: _pageType == PageType.COLLECT,
                          onTap: () {
                            if (_pageType == PageType.COLLECT) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _pageType = PageType.COLLECT;
                              _pageTypeMap[_pageType] = true;
                            });
                          });
                  }

                  return Container();
                }).toList(),
              ),

              // 分割线
              Divider(color: AppColor.line),

              // 设置
              _buildDrawerItem(
                  icon: Icons.settings,
                  title: S.of(context).setting,
                  isTarget: false,
                  onTap: () async {
                    _weatherKey.currentState?.changeHideState(true);
                    await push(context, page: SettingPage());
                    if (_pageType == PageType.WEATHER) {
                      _weatherKey.currentState?.changeHideState(false);
                    }
                  }),

              // 关于
              _buildDrawerItem(
                  icon: Icons.error_outline,
                  title: S.of(context).about,
                  isTarget: false,
                  onTap: () async {
                    _weatherKey.currentState?.changeHideState(true);
                    await push(context, page: AboutPage());
                    if (_pageType == PageType.WEATHER) {
                      _weatherKey.currentState?.changeHideState(false);
                    }
                  }),
            ],
          ),
        ),
        body: _buildBody(),
      ),
      onWillPop: () async {
        if (_readyExit) {
          exitApp();
        } else {
          _readyExit = true;
          _exitTimer =
              Timer(const Duration(seconds: 2), () => _readyExit = false);
          showSnack(text: S.of(context).retryToExit);
        }

        return false;
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
            child: _pageTypeMap[PageType.WEATHER]
                ? WeatherPage(key: _weatherKey)
                : Container(),
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

        // 干货页面
        Offstage(
          offstage: _pageType != PageType.GANHUO,
          child: TickerMode(
            enabled: _pageType == PageType.GANHUO,
            child: _pageTypeMap[PageType.GANHUO] ? GanHuoPage() : Container(),
          ),
        ),

        // 收藏页面
        Offstage(
          offstage: _pageType != PageType.COLLECT,
          child: TickerMode(
            enabled: _pageType == PageType.COLLECT,
            child: _pageTypeMap[PageType.COLLECT] ? FavPage() : Container(),
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
      @required VoidCallback onTap}) {
    return Material(
      child: InkWell(
        onTap: () {
          // 点击后关闭抽屉
          pop(context);

          onTap();
        },
        child: Container(
          color: isTarget ? AppColor.shadow : Colors.transparent,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color:
                    isTarget ? Theme.of(context).accentColor : AppColor.text2,
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

  /// 干货页面
  GANHUO,

  /// 收藏页面
  COLLECT,
}
