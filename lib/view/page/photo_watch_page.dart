import 'package:flutter_weather/commom_import.dart';

class PhotoWatchPage<T> extends StatefulWidget {
  final int index;
  final int length;
  final List<MziData> photos;
  final Stream<List<MziData>> photoStream;

  PhotoWatchPage(
      {@required this.index,
      @required this.length,
      @required this.photos,
      @required this.photoStream});

  @override
  State createState() => PhotoWatchState(
      index: index, length: length, photos: photos, photoStream: photoStream);
}

class PhotoWatchState<T> extends PageState<PhotoWatchPage> {
  final Stream<List<MziData>> photoStream;
  final List<MziData> photos;
  final int length;
  final PageController _pageController;
  final PhotoWatchViewModel _viewModel;

  int _currentPage = 0;
  bool canScroll = true;

  PhotoWatchState(
      {@required int index,
      @required this.length,
      @required this.photos,
      @required this.photoStream})
      : _pageController = PageController(initialPage: index),
        _viewModel = PhotoWatchViewModel(photoStream: photoStream),
        _currentPage = index;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: _viewModel.data.stream,
        builder: (context, snapshot) {
          final List<MziData> list = snapshot.data ?? photos;

          if (list.length < length) {
            list.addAll(List.generate(length - list.length, (_) => null));
          }

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
                  PhotoViewGallery(
                    pageController: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    loadingChild: Center(
                      child: Image.asset("images/loading.gif"),
                    ),
                    pageOptions: list.map(
                      (data) {
                        return PhotoViewGalleryPageOptions(
                          heroTag: data?.url,
                          imageProvider: data != null
                              ? CachedNetworkImageProvider(
//                          data.url,
                                  "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
                                  headers: Map<String, String>()
                                    ..["Referer"] = data.refer,
                                )
                              : AssetImage("images/loading.gif"),
                          minScale: data != null ? 0.1 : 1.0,
                          maxScale: data != null ? 5.0 : 1.0,
                        );
                      },
                    ).toList(),
                  ),

                  // 标题栏
                  CustomAppBar(
                    title: Text(
                      AppText.of(context).imageSet,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    showShadowLine: false,
                    color: Colors.transparent,
                    leftBtn: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => pop(context),
                    ),
                    rightBtns: <Widget>[
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () =>
                            FavHolder().autoFav(list[_currentPage]),
                      ),
                    ],
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
