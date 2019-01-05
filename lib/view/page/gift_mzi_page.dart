import 'package:flutter_weather/commom_import.dart';

class GiftMziPage extends StatefulWidget {
  @override
  State createState() => GiftMziState();
}

class GiftMziState extends PageState<GiftMziPage> {
  final _viewModel = GiftMziViewModel();

  @override
  void initState() {
    super.initState();

    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.datas.stream,
          builder: (context, snapshot) {
            final List<MziData> datas = snapshot.data ?? List();

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(type: LoadType.REFRESH),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: const ClampingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                itemCount: datas.length,
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  final data = datas[index];
                  final headers = Map<String, String>();
                  headers["Referer"] = data.refer;

                  // 在倒数第5个item显示时就加载下一页
                  if (index + 1 >= datas.length - 5) {
                    _viewModel.loadMore();
                  }

                  return GestureDetector(
                    onTap: () => push(context, page: PhotoWatchPage()),
                    child: AspectRatio(
                      aspectRatio: data.width / data.height,
                      child: NetImage(
                        headers: headers,
//                      url: data.url,
                        url:
                            "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
