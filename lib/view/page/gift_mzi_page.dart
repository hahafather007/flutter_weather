import 'package:flutter_weather/commom_import.dart';

class GiftMziPage extends StatefulWidget {
  @override
  State createState() => GiftMziState();
}

class GiftMziState extends PageState<GiftMziPage> {
  GiftMziViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = GiftMziViewModel()..init();
  }

  @override
  void dispose() {
    super.dispose();

    _viewModel?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingView(
        key: loadingKey,
        child: StreamBuilder(
          stream: _viewModel.datas.stream,
          builder: (context, snapshot) {
            final List<MziData> datas = snapshot.data ?? List();

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(),
              child: SmartRefresher(
                enablePullUp: false,
                enableOverScroll: false,
                enablePullDown: false,
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                  itemCount: datas.length,
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    final data = datas[index];
                    final headers = Map<String, String>();
                    headers["Referer"] = data.refer;

                    return AspectRatio(
                      aspectRatio: data.width / data.height,
                      child: NetImage(
                        headers: headers,
                        url: data.url,
//                        url:
//                            "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
                        height: null,
                        width: null,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
