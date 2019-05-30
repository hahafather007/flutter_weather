import 'package:flutter_weather/commom_import.dart';

class FavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          CustomAppBar(
            title: Text(
              AppText.of(context).collect,
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
                Tab(text: AppText.of(context).read),
                Tab(text: AppText.of(context).gift),
                Tab(text: AppText.of(context).giftPhotos),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColor.colorRead,
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
