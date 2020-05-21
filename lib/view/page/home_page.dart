import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/page_module_data.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_weather/model/holder/weather_holder.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/about_page.dart';
import 'package:flutter_weather/view/page/fav_page.dart';
import 'package:flutter_weather/view/page/ganhuo_page.dart';
import 'package:flutter_weather/view/page/gift_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/read_page.dart';
import 'package:flutter_weather/view/page/setting_page.dart';
import 'package:flutter_weather/view/page/weather_page.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends PageState<HomePage> {
  /// 标识有效页面
  final _pageTypeMap = {
    PageType.WEATHER: false,
    PageType.READ: false,
    PageType.GIFT: false,
    PageType.COLLECT: false,
    PageType.GANHUO: false,
  };
  final _weatherKey = GlobalKey<WeatherState>();
  final _pageModules = List<PageModule>();

  /// 当前显示页面
  PageType _currentPage;
  Timer _exitTimer;

  @override
  void initState() {
    super.initState();

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

    _initModules();
  }

  @override
  void dispose() {
    FavHolder().dispose();
    WeatherHolder().dispose();
    _exitTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                children: _pageModules
                    .where((v) => v.open)
                    .map((v) => v.page)
                    .map((page) {
                  switch (page) {
                    // 天气
                    case PageType.WEATHER:
                      return _buildDrawerItem(
                          icon: Icons.wb_sunny,
                          title: S.of(context).weather,
                          isTarget: _currentPage == page,
                          onTap: () {
                            if (_currentPage == page) return;

                            _weatherKey.currentState?.changeHideState(false);
                            setState(() {
                              _currentPage = page;
                              _pageTypeMap[page] = true;
                            });
                          });

                    // 福利
                    case PageType.GIFT:
                      return _buildDrawerItem(
                          icon: Icons.card_giftcard,
                          title: S.of(context).gift,
                          isTarget: _currentPage == page,
                          onTap: () {
                            if (_currentPage == page) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _currentPage = page;
                              _pageTypeMap[page] = true;
                            });
                          });

                    // 闲读
                    case PageType.READ:
                      return _buildDrawerItem(
                          icon: Icons.local_cafe,
                          title: S.of(context).read,
                          isTarget: _currentPage == page,
                          onTap: () {
                            if (_currentPage == page) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _currentPage = page;
                              _pageTypeMap[page] = true;
                            });
                          });

                    // 干货
                    case PageType.GANHUO:
                      return _buildDrawerItem(
                          icon: Icons.android,
                          title: S.of(context).ganHuo,
                          isTarget: _currentPage == page,
                          onTap: () {
                            if (_currentPage == page) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _currentPage = page;
                              _pageTypeMap[page] = true;
                            });
                          });

                    // 闲读
                    case PageType.COLLECT:
                      return _buildDrawerItem(
                          icon: Icons.favorite_border,
                          title: S.of(context).collect,
                          isTarget: _currentPage == page,
                          onTap: () {
                            if (_currentPage == page) return;

                            _weatherKey.currentState?.changeHideState(true);
                            setState(() {
                              _currentPage = page;
                              _pageTypeMap[page] = true;
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
                    if (_currentPage == PageType.WEATHER) {
                      _weatherKey.currentState?.changeHideState(false);
                    }

                    /// 导航栏功能可能会改变
                    _moduleChanged();
                  }),

              // 关于
              _buildDrawerItem(
                  icon: Icons.error_outline,
                  title: S.of(context).about,
                  isTarget: false,
                  onTap: () async {
                    _weatherKey.currentState?.changeHideState(true);
                    await push(context, page: AboutPage());
                    if (_currentPage == PageType.WEATHER) {
                      _weatherKey.currentState?.changeHideState(false);
                    }
                  }),
            ],
          ),
        ),
        body: _buildBody(),
      ),
      onWillPop: () async => false,
    );
  }

  /// 利用[IndexedStack]和[TickerMode]配合实现懒加载
  /// 当所有页面关闭时显示占位图片
  Widget _buildBody() {
    return _currentPage != null
        ? Stack(
            children: <Widget>[
              // 天气
              Offstage(
                offstage: _currentPage != PageType.WEATHER,
                child: TickerMode(
                  enabled: _currentPage == PageType.WEATHER,
                  child: _pageTypeMap[PageType.WEATHER]
                      ? WeatherPage(key: _weatherKey)
                      : Container(),
                ),
              ),

              // 福利
              Offstage(
                offstage: _currentPage != PageType.GIFT,
                child: TickerMode(
                  enabled: _currentPage == PageType.GIFT,
                  child: _pageTypeMap[PageType.GIFT] ? GiftPage() : Container(),
                ),
              ),

              // 闲读
              Offstage(
                offstage: _currentPage != PageType.READ,
                child: TickerMode(
                  enabled: _currentPage == PageType.READ,
                  child: _pageTypeMap[PageType.READ] ? ReadPage() : Container(),
                ),
              ),

              // 干货
              Offstage(
                offstage: _currentPage != PageType.GANHUO,
                child: TickerMode(
                  enabled: _currentPage == PageType.GANHUO,
                  child: _pageTypeMap[PageType.GANHUO]
                      ? GanHuoPage()
                      : Container(),
                ),
              ),

              // 收藏
              Offstage(
                offstage: _currentPage != PageType.COLLECT,
                child: TickerMode(
                  enabled: _currentPage == PageType.COLLECT,
                  child:
                      _pageTypeMap[PageType.COLLECT] ? FavPage() : Container(),
                ),
              ),
            ],
          )
        : Center(
            child: Image.asset("images/nothing_here.gif"),
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

  /// 初始化首次启动的界面
  void _initModules() {
    _pageModules
      ..clear()
      ..addAll(SharedDepository().pageModules);

    // 优先显示天气
    int index =
        _pageModules.indexWhere((v) => v.page == PageType.WEATHER && v.open);
    if (index == -1) {
      // 当天气功能被关闭时，显示第一个未被关闭的界面
      index = _pageModules.indexWhere((v) => v.open);
    }

    if (index != -1) {
      _currentPage = _pageModules[index].page;
      _pageTypeMap[_pageModules[index].page] = true;
    }
  }

  /// 当页面顺序改变时调用
  void _moduleChanged() {
    if (_pageModules == SharedDepository().pageModules) return;

    setState(() {
      _pageModules
        ..clear()
        ..addAll(SharedDepository().pageModules)
        ..where((v) => !v.open).map((v) => v.page).forEach((page) {
          // 如果当前页面被关闭，就重新寻找显示的页面
          if (_currentPage == page) {
            _currentPage = null;
          }
          _pageTypeMap[page] = false;
        });

      if (_currentPage == null) {
        _currentPage =
            _pageModules.firstWhere((v) => v.open, orElse: () => null)?.page;
        if (_currentPage != null) {
          _pageTypeMap[_currentPage] = true;
        }
      }
    });
  }
}
