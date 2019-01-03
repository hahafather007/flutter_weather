import 'package:flutter_weather/commom_import.dart';

class ReadPage extends StatefulWidget {
  final ReadState _state = ReadState();

  @override
  State createState() {
    debugPrint("========>ReadPage");

    return _state;
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    _state.setDrawerOpenFunc(openDrawer: openDrawer);
  }
}

class ReadState extends PageState<ReadPage> {
  List<Tab> _tabItems;

  Function openDrawer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabItems == null) {
      _tabItems = [
        Tab(text: AppText.of(context).xiandu),
        Tab(text: AppText.of(context).xianduApps),
        Tab(text: AppText.of(context).xianduImrich),
        Tab(text: AppText.of(context).xianduFunny),
        Tab(text: AppText.of(context).xianduAndroid),
        Tab(text: AppText.of(context).xianduDie),
        Tab(text: AppText.of(context).xianduThink),
        Tab(text: AppText.of(context).xianduIos),
        Tab(text: AppText.of(context).xianduBlog),
      ];
    }

    return Scaffold(
      appBar: CustomAppBar(
        showShadowLine: false,
        title: Text(
          AppText.of(context).read,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        color: AppColor.colorMain,
        leftBtn: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: openDrawer,
        ),
      ),
      body: DefaultTabController(
        length: _tabItems.length ?? 0,
        child: Container(
          color: AppColor.colorMain,
          child: Column(
            children: <Widget>[
              TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: _tabItems,
              ),
              Container(height: 1, color: AppColor.colorShadow),
              Expanded(
                child: Container(
                  color: AppColor.colorGround,
                  child: TabBarView(
                    children: [
                      ReadContentPage(),
                      ReadContentPage(),
                      ReadContentPage(),
                      ReadContentPage(),
                      ReadContentPage(),
                      ReadContentPage(),
                      ReadContentPage(),
                      ReadContentPage(),
                      ReadContentPage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    this.openDrawer = openDrawer;
  }
}
