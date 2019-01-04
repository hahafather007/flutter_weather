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
  List<String> _retryTitles = List();
  Function _openDrawer;

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
      key: scafKey,
      appBar: CustomAppBar(
        showShadowLine: false,
        title: Text(
          AppText.of(context).read,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        color: AppColor.colorMain,
        leftBtn: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: _openDrawer,
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
                  color: AppColor.colorRead,
                  child: TabBarView(
                    children: [
                      ReadContentPage(
                          typeUrl: "wow",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xiandu, retry: retry)),
                      ReadContentPage(
                          typeUrl: "apps",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduApps,
                              retry: retry)),
                      ReadContentPage(
                          typeUrl: "imrich",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduImrich,
                              retry: retry)),
                      ReadContentPage(
                          typeUrl: "funny",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduFunny,
                              retry: retry)),
                      ReadContentPage(
                          typeUrl: "android",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduAndroid,
                              retry: retry)),
                      ReadContentPage(
                          typeUrl: "diediedie",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduDie,
                              retry: retry)),
                      ReadContentPage(
                          typeUrl: "thinking",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduThink,
                              retry: retry)),
                      ReadContentPage(
                          typeUrl: "iOS",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduIos,
                              retry: retry)),
                      ReadContentPage(
                          typeUrl: "teamblog",
                          retryCallback: (retry) => showRetryBar(
                              title: AppText.of(context).xianduBlog,
                              retry: retry)),
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
    this._openDrawer = openDrawer;
  }

  void showRetryBar({@required String title, @required Function retry}) {
    if(_retryTitles.contains(title)){
      scafKey.currentState.removeCurrentSnackBar();
      _retryTitles.remove(title);
    }
    _retryTitles.add(title);
    scafKey.currentState.showSnackBar(SnackBar(
      content: Text("$title${AppText.of(context).loadFail}"),
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: AppText.of(context).retry,
        onPressed: (){
          retry();
          _retryTitles.remove(title);
        },
      ),
    ));
  }
}
