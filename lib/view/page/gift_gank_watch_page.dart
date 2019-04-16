import 'package:flutter_weather/commom_import.dart';

class GiftGankWatchPage extends StatefulWidget {
  final int index;
  final List<MziData> photos;
  final Stream<List<MziData>> photoStream;
  final Function loadDataFun;

  GiftGankWatchPage(
      {@required this.index,
      @required this.photos,
      @required this.photoStream,
      @required this.loadDataFun});

  @override
  State createState() => GiftGankWatchState();
}

class GiftGankWatchState extends PageState<GiftGankWatchPage> {
  PageController _pageController;
  PhotoWatchViewModel _viewModel;

  int _currentPage = 0;
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();

    _currentPage = widget.index;
    _pageController =
        PageController(initialPage: _currentPage, keepPage: false);
    _viewModel = PhotoWatchViewModel(photoStream: widget.photoStream);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: _viewModel.data.stream,
        builder: (context, snapshot) {
          final List<MziData> list = (snapshot.data ?? widget.photos).toList();

          list.addAll(List.generate(9999, (_) => null));

          return StreamBuilder(
            stream: _viewModel.favList.stream,
            builder: (context, snapshot) {
              final List<MziData> favList = snapshot.data ?? List();
              final isFav = favList.any((v) =>
                  v.url == list[_currentPage]?.url &&
                  v.url == list[_currentPage]?.url);

              return Stack(
                children: <Widget>[
                  // 图片浏览
                  GestureDetector(
                    onTap: () => setState(() => _showAppBar = !_showAppBar),
                    child: PhotoViewGallery(
                      pageController: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                        if (list[index] == null) {
                          widget.loadDataFun();
                        }
                      },
                      loadingChild: Center(
                        child: Image.asset(
                          "images/loading.gif",
                          scale: 0.5,
                        ),
                      ),
                      pageOptions: list
                          .map(
                            (data) => data != null
                                ? PhotoViewGalleryPageOptions(
                                    heroTag: data.url,
                                    imageProvider:
                                        CachedNetworkImageProvider(data.url),
                                    minScale: 0.1,
                                    maxScale: 5.0,
                                  )
                                : PhotoViewGalleryPageOptions(
                                    imageProvider:
                                        AssetImage("images/loading.gif"),
                                    minScale: 0.5,
                                    maxScale: 0.5,
                                  ),
                          )
                          .toList(),
                    ),
                  ),

                  // 标题栏
                  AnimatedOpacity(
                    opacity: _showAppBar ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomAppBar(
                      title: Text(""),
                      showShadowLine: false,
                      color: Colors.transparent,
                      leftBtn: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (!_showAppBar) return;

                          pop(context);
                        },
                      ),
                      rightBtns: <Widget>[
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            if (!_showAppBar) return;

                            FavHolder().autoFav(list[_currentPage]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
