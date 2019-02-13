import 'package:flutter_weather/commom_import.dart';

class ReadPage extends StatefulWidget {
  @override
  State createState() => ReadState();
}

class ReadState extends PageState<ReadPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomAppBar(
          showShadowLine: false,
          title: Text(
            AppText.of(context).read,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          color: AppColor.colorMain,
          leftBtn: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => EventSendHolder().sendEvent(tag: "homeDrawerOpen", event: true),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 9,
            child: Container(
              color: AppColor.colorMain,
              child: Column(
                children: <Widget>[
                  TabBar(
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    isScrollable: true,
                    tabs: [
                      Tab(text: AppText.of(context).xiandu),
                      Tab(text: AppText.of(context).xianduApps),
                      Tab(text: AppText.of(context).xianduImrich),
                      Tab(text: AppText.of(context).xianduFunny),
                      Tab(text: AppText.of(context).xianduAndroid),
                      Tab(text: AppText.of(context).xianduDie),
                      Tab(text: AppText.of(context).xianduThink),
                      Tab(text: AppText.of(context).xianduIos),
                      Tab(text: AppText.of(context).xianduBlog),
                    ],
                  ),
                  Container(height: 1, color: AppColor.colorShadow),
                  Expanded(
                    child: Container(
                      color: AppColor.colorRead,
                      child: TabBarView(
                        children: [
                          ReadContentPage(typeUrl: "wow"),
                          ReadContentPage(typeUrl: "apps"),
                          ReadContentPage(typeUrl: "imrich"),
                          ReadContentPage(typeUrl: "funny"),
                          ReadContentPage(typeUrl: "android"),
                          ReadContentPage(typeUrl: "diediedie"),
                          ReadContentPage(typeUrl: "thinking"),
                          ReadContentPage(typeUrl: "iOS"),
                          ReadContentPage(typeUrl: "teamblog"),
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
