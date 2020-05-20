import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/view/page/gift_egg_page.dart';
import 'package:flutter_weather/view/page/gift_gank_page.dart';
import 'package:flutter_weather/view/page/gift_mzi_page.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';

class GiftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        children: <Widget>[
          CustomAppBar(
            title: Text(
              S.of(context).gift,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            color: Theme.of(context).accentColor,
            leftBtn: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => EventSendHolder()
                  .sendEvent(tag: "homeDrawerOpen", event: true),
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: [
                Tab(text: S.of(context).egg),
                Tab(text: S.of(context).gank),
                Tab(text: S.of(context).beachGirl),
                Tab(text: S.of(context).mostHot),
                Tab(text: S.of(context).taiwanGirl),
                Tab(text: S.of(context).sexGirl),
                Tab(text: S.of(context).japanGirl),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColor.read,
              child: TabBarView(
                children: [
                  GiftEggPage(
                    key: Key("GiftEggPage"),
                  ),
                  GiftGankPage(
                    key: Key("GiftGankPage"),
                  ),
                  GiftMziPage(
                    key: Key("GiftMziPagemm"),
                    typeUrl: "mm",
                  ),
                  GiftMziPage(
                    key: Key("GiftMziPagehot"),
                    typeUrl: "hot",
                  ),
                  GiftMziPage(
                    key: Key("GiftMziPagetaiwan"),
                    typeUrl: "taiwan",
                  ),
                  GiftMziPage(
                    key: Key("GiftMziPagexinggan"),
                    typeUrl: "xinggan",
                  ),
                  GiftMziPage(
                    key: Key("GiftMziPagejapan"),
                    typeUrl: "japan",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
