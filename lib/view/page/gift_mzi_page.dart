import 'package:flutter_weather/commom_import.dart';

class GiftMziPage extends StatefulWidget {
  final String typeUrl;

  GiftMziPage({@required this.typeUrl});

  @override
  State createState() => GiftMziState(typeUrl: typeUrl);
}

class GiftMziState extends PageState<GiftMziPage>
    with AutomaticKeepAliveClientMixin {
  final String typeUrl;
  final _viewModel = GiftMziViewModel();
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  GiftMziState({@required this.typeUrl});

  @override
  void initState() {
    super.initState();

    _viewModel.init(typeUrl: typeUrl);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.data.stream,
          builder: (context, snapshot) {
            final List<MziData> list = snapshot.data ?? List();

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(type: LoadType.REFRESH),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: const ClampingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                itemCount: list.length,
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  final data = list[index];
                  final headers = Map<String, String>();
                  headers["Referer"] = data.refer;

                  // 在倒数第5个item显示时就加载下一页
                  if (index + 1 >= list.length - 5) {
                    _viewModel.loadMore();
                  }

                  return GestureDetector(
                    onTap: () => push(context,
                        page: PhotoWatchPage(
                          index: index,
                          loadPhotos: () => _viewModel.loadMore(),
                          photos: list,
                          photoStream: _viewModel.photoStream,
                        )),
                    child: data.height != -1 && data.width != -1
                        ? AspectRatio(
                            aspectRatio: data.width / data.height,
                            child: NetImage(
                              headers: headers,
//                          url: data.url,
                              url:
                                  "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
                            ),
                          )
                        : NetImage(
                            headers: headers,
//                          url: data.url,
                            url:
                                "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
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
