import 'package:flutter_weather/commom_import.dart';

class GiftPage extends StatefulWidget {
  @override
  State createState() => GiftState();
}

class GiftState extends PageState<GiftPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomAppBar(
          showShadowLine: false,
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
            onPressed: () =>
                EventSendHolder().sendEvent(tag: "homeDrawerOpen", event: true),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 8,
            child: Container(
              color: Theme.of(context).accentColor,
              child: Column(
                children: <Widget>[
                  TabBar(
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    isScrollable: true,
                    tabs: [
                      Tab(text: AppText.of(context).gank),
                      Tab(text: AppText.of(context).egg),
                      Tab(text: AppText.of(context).mostHot),
                      Tab(text: AppText.of(context).sexGirl),
                      Tab(text: AppText.of(context).japanGirl),
                      Tab(text: AppText.of(context).taiwanGirl),
                      Tab(text: AppText.of(context).beachGirl),
                      Tab(text: AppText.of(context).selfGirl),
                    ],
                  ),
                  Container(height: 1, color: AppColor.colorShadow),
                  Expanded(
                    child: Container(
                      color: AppColor.colorRead,
                      child: TabBarView(
                        children: [
                          GiftGankPage(),
                          GiftEggPage(),
                          GiftMziPage(typeUrl: "hot"),
                          GiftMziPage(typeUrl: "xinggan"),
                          GiftMziPage(typeUrl: "japan"),
                          GiftMziPage(typeUrl: "taiwan"),
                          GiftMziPage(typeUrl: "mm"),
                          GiftMziPage(typeUrl: "share"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
