import 'package:flutter_weather/commom_import.dart';

class GiftMziImagePage extends StatefulWidget {
  final String link;

  GiftMziImagePage({@required this.link});

  @override
  State createState() => GiftMziImageState(link: link);
}

class GiftMziImageState extends PageState<GiftMziImagePage> {
  final String link;
  final _viewModel = GiftMziImageViewModel();

  GiftMziImageState({@required this.link});

  @override
  void initState() {
    super.initState();

    _viewModel.loadData(link: link);
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          AppText.of(context).imageSet,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        color: AppColor.colorMain,
        leftBtn: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => pop(context),
        ),
      ),
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.data.stream,
          builder: (context, snapshot) {
            final List<MziData> list = snapshot.data ?? List();

            return StreamBuilder(
              stream: _viewModel.dataLength.stream,
              builder: (context, snapshot) {
                final length = snapshot.data ?? 0;

                return RefreshIndicator(
                  onRefresh: () => _viewModel.loadData(link: link),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: const ClampingScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                    itemCount: list.length,
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      final data = list[index];
                      final headers = Map<String, String>();
                      headers["Referer"] = data.refer;

                      return GestureDetector(
                        onTap: () {
                          debugPrint("list======>${list.length}");

                          push(context,
                              page: PhotoWatchPage(
                                index: index,
                                length: length,
                                photos: list,
                                photoStream: _viewModel.photoStream,
                              ));
                        },
                        child: AspectRatio(
                          aspectRatio: data.width / data.height,
                          child: Hero(
                            tag: data.url,
                            child: NetImage(
                              headers: headers,
                          url: data.url,
//                              url:
//                                  "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
                              placeholder: Center(
                                child: Image.asset(
                                  "images/loading.gif",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
