import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/view/page/fav_gift_page.dart';
import 'package:flutter_weather/view/page/fav_gifts_page.dart';
import 'package:flutter_weather/view/page/fav_read_page.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';

class FavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          CustomAppBar(
            title: Text(
              S.of(context).collect,
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
              tabs: [
                Tab(text: S.of(context).readOrGanHuo),
                Tab(text: S.of(context).gift),
                Tab(text: S.of(context).giftPhotos),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColor.read,
              child: TabBarView(
                children: <Widget>[
                  FavReadPage(
                    key: Key("FavReadPage"),
                  ),
                  FavGiftPage(
                    key: Key("FavGiftPage"),
                  ),
                  FavGiftsPage(
                    key: Key("FavGiftsPage"),
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
