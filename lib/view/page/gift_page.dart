import 'package:flutter_weather/commom_import.dart';

class GiftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        children: <Widget>[
          CustomAppBar(
            title: Text(
              AppText.of(context).gift,
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
                Tab(text: AppText.of(context).gank),
                Tab(text: AppText.of(context).egg),
                Tab(text: AppText.of(context).beachGirl),
                Tab(text: AppText.of(context).mostHot),
                Tab(text: AppText.of(context).taiwanGirl),
                Tab(text: AppText.of(context).sexGirl),
                Tab(text: AppText.of(context).japanGirl),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColor.colorRead,
              child: TabBarView(
                children: [
                  GiftGankPage(
                    key: Key("GiftGankPage"),
                  ),
                  GiftEggPage(
                    key: Key("GiftEggPage"),
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
