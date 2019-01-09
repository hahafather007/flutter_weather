import 'package:flutter_weather/commom_import.dart';

class PhotoWatchPage<T> extends StatefulWidget {
  final int index;
  final int length;
  final List<MziData> photos;
  final Stream<List<MziData>> photoStream;

  /// 收藏时保存在本地的数据
  final T favData;

  PhotoWatchPage(
      {@required this.index,
      @required this.length,
      @required this.photos,
      @required this.photoStream,
      @required this.favData});

  @override
  State createState() => PhotoWatchState(
      index: index,
      length: length,
      photos: photos,
      photoStream: photoStream,
      favData: favData);
}

class PhotoWatchState<T> extends PageState<PhotoWatchPage> {
  final Stream<List<MziData>> photoStream;
  final List<MziData> photos;
  final int length;
  final T favData;
  final PageController _pageController;
  final PhotoWatchViewModel _viewModel;

  bool canScroll = true;

  PhotoWatchState(
      {@required int index,
      @required this.length,
      @required this.photos,
      @required this.photoStream,
      @required this.favData})
      : _pageController = PageController(initialPage: index),
        _viewModel =
            PhotoWatchViewModel(favData: null, photoStream: photoStream);

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

          return PhotoViewGallery(
            pageController: _pageController,
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
          );
        },
      ),
    );
  }
}
