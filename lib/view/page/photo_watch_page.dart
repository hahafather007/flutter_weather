import 'package:flutter_weather/commom_import.dart';

class PhotoWatchPage extends StatefulWidget {
  final int index;
  final Function loadPhotos;
  final List<MziData> photos;
  final Stream<List<MziData>> photoStream;

  PhotoWatchPage(
      {@required this.index,
      @required this.loadPhotos,
      @required this.photos,
      @required this.photoStream});

  @override
  State createState() => PhotoWatchState(
      index: index,
      loadPhotos: loadPhotos,
      photos: photos,
      photoStream: photoStream);
}

class PhotoWatchState extends PageState<PhotoWatchPage> {
  final Function loadPhotos;
  final Stream<List<MziData>> photoStream;
  final List<MziData> photos;
  final PageController _pageController;
  final _viewModel = PhotoWatchViewModel();

  bool canScroll = true;

  PhotoWatchState(
      {@required int index,
      @required this.loadPhotos,
      @required this.photos,
      @required this.photoStream})
      : _pageController = PageController(initialPage: index, keepPage: false);

  @override
  void initState() {
    super.initState();

    _viewModel.init(photoStream);
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
        stream: _viewModel.datas.stream,
        builder: (context, snapshot) {
          final List<MziData> list = snapshot.data ?? photos;

          return PageView.builder(
            controller: _pageController,
            physics: canScroll
                ? AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (list.length - 1 <= index) {
                loadPhotos();
              }

              return list.length > index
                  ? ZoomableWidget(
                      maxScale: 2,
                      child: Hero(
                        tag: list[index].url,
                        child: NetImage(
//                      url: list[index].url,
                          url:
                              "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
                        ),
                      ),
                      onZoomStateChanged: (scale) {
                        debugPrint("scale====>$scale");
                        setState(() => canScroll = scale == 1);
                      },
                    )
                  : Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
