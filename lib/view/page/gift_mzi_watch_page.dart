import 'package:flutter_weather/commom_import.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'dart:typed_data' show Uint8List;

class GiftMziWatchPage extends StatefulWidget {
  final int index;
  final int length;
  final List<MziData> photos;
  final Stream<List<MziData>> photoStream;

  GiftMziWatchPage(
      {@required this.index,
      @required this.length,
      @required this.photos,
      @required this.photoStream});

  @override
  State createState() => GiftMziWatchState();
}

class GiftMziWatchState extends PageState<GiftMziWatchPage> {
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

          if (list.length < widget.length) {
            list.addAll(
                List.generate(widget.length - list.length, (_) => null));
          }

          return StreamBuilder(
            stream: _viewModel.favList.stream,
            builder: (context, snapshot) {
              final List<MziData> favList = snapshot.data ?? [];
              final isFav = favList.any((v) =>
                  v.url == list[_currentPage]?.url &&
                  v.isImages == list[_currentPage]?.isImages);

              return GestureDetector(
                onTap: () => setState(() => _showAppBar = !_showAppBar),
                child: Stack(
                  children: <Widget>[
                    // 图片浏览
                    PageView.builder(
                      itemCount: list.length,
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        final data = list[index];

                        if (data == null) {
                          return Center(
                            child: const CupertinoActivityIndicator(),
                          );
                        } else {
                          final zoomImg = ZoomableWidget(
                            maxScale: 5,
                            minScale: 0.1,
                            child: NetImage(
                              url: data.url,
                              placeholder: Center(
                                child: const CupertinoActivityIndicator(),
                              ),
                              fit: BoxFit.contain,
                            ),
                          );

                          return index == _currentPage
                              ? Hero(
                                  tag:
                                      "${data.url}$index${widget.photoStream != null}",
                                  child: zoomImg,
                                )
                              : zoomImg;
                        }
                      },
                    ),

                    // 标题栏
                    AnimatedOpacity(
                      opacity: _showAppBar ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: CustomAppBar(
                        title: Text(""),
                        showShadow: false,
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
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: "save",
                                    child: Text(AppText.of(context).imgSave),
                                  ),
                                ],
                            onSelected: (value) async {
                              switch (value) {
                                case "save":
                                  final file = await DefaultCacheManager()
                                      .getSingleFile(list[_currentPage].url);

                                  await SimplePermissions.requestPermission(
                                      Permission.ReadExternalStorage);
                                  if (file != null) {
                                    final u8 = Uint8List.fromList(
                                        file.readAsBytesSync());
                                    await ImageGallerySaver.save(u8);
                                    showSnack(
                                        text:
                                            AppText.of(context).imgSaveSuccess);
                                  } else {
                                    showSnack(
                                        text: AppText.of(context).imgSaveFail);
                                  }
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
