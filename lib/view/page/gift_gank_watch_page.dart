import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';
import 'package:flutter_weather/view/widget/net_image.dart';
import 'package:flutter_weather/view/widget/watcher_popup_btn.dart';
import 'package:flutter_weather/view/widget/zoomable_widget.dart';
import 'package:flutter_weather/viewmodel/photo_watch_viewmodel.dart';

class GiftGankWatchPage extends StatefulWidget {
  final int index;
  final int max;
  final List<MziItem> photos;
  final Stream<List<MziItem>> photoStream;
  final VoidCallback loadDataFun;

  GiftGankWatchPage(
      {@required this.index,
      @required this.max,
      @required this.photos,
      this.photoStream,
      this.loadDataFun});

  @override
  State createState() => GiftGankWatchState();
}

class GiftGankWatchState extends PageState<GiftGankWatchPage> {
  PageController _pageController;
  PhotoWatchViewModel _viewModel;
  int _currentPage = 0;
  bool _showAppBar = false;
  bool _canScroll = true;

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
      key: scafKey,
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: _viewModel.data.stream,
        builder: (context, snapshot) {
          final List<MziItem> list = (snapshot.data ?? widget.photos).toList();

          if (widget.photoStream != null) {
            list.addAll(List.generate(widget.max - list.length, (_) => null));
          }
          return StreamBuilder(
            stream: _viewModel.favList.stream,
            builder: (context, snapshot) {
              final List<MziItem> favList = snapshot.data ?? [];
              final isFav = favList.any((v) =>
                  v.url == list[_currentPage]?.url &&
                  v.isImages == list[_currentPage]?.isImages);

              return GestureDetector(
                onTap: () => setState(() => _showAppBar = !_showAppBar),
                child: Stack(
                  children: <Widget>[
                    PageView.builder(
                      itemCount: list.length,
                      controller: _pageController,
                      physics: _canScroll
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                        if (list[index] == null && widget.loadDataFun != null) {
                          widget.loadDataFun();
                        }
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
                            minScale: 1,
                            child: NetImage(
                              url: data.url,
                              placeholder: Center(
                                child: const CupertinoActivityIndicator(),
                              ),
                              fit: BoxFit.contain,
                            ),
                            onZoomChanged: (scale) {
                              if (index != _currentPage) return;

                              final scroll = scale == 1;
                              if (scroll != _canScroll) {
                                setState(() => _canScroll = scroll);
                              }
                            },
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
                          WatcherPopupBtn(
                            url: list[_currentPage]?.url,
                            onSnackShow: (text) {
                              showSnack(text: text);
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
