import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/gift_photo_watch_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/view/widget/net_image.dart';
import 'package:flutter_weather/viewmodel/gift_gank_viewmodel.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftGankPage extends StatefulWidget {
  GiftGankPage({Key key}) : super(key: key);

  @override
  State createState() => GiftGankState();
}

class GiftGankState extends PageState<GiftGankPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = GiftGankViewModel();
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // 滑到底部加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _viewModel.loadMore();
      }
    });

    _viewModel
      ..loadData(type: LoadType.NEW_LOAD)
      ..error
          .stream
          .where((b) => b)
          .listen((_) => networkError(
              errorText: S.of(context).gankFail, retry: _viewModel.reload))
          .bindLife(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      key: scafKey,
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.data.stream,
          builder: (context, snapshot) {
            final List<MziItem> list = snapshot.data ?? [];

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

                  return RepaintBoundary(
                    child: GestureDetector(
                      onTap: () => push(context,
                          page: GiftPhotoWatchPage(
                              index: index,
                              photos: list,
                              photoStream: _viewModel.photoStream,
                              loadDataFun: () => _viewModel.loadMore())),
                      child: AspectRatio(
                        aspectRatio: data.width / data.height,
                        child: Hero(
                          tag: "${data.url}${index}true",
                          child: NetImage(url: data.url),
                        ),
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
