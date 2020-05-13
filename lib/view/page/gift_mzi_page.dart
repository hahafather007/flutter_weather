import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/gift_mzi_image_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/view/widget/net_image.dart';
import 'package:flutter_weather/viewmodel/gift_mzi_viewmodel.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class GiftMziPage extends StatefulWidget {
  final String typeUrl;

  GiftMziPage({Key key, @required this.typeUrl}) : super(key: key);

  @override
  State createState() => GiftMziState();
}

class GiftMziState extends PageState<GiftMziPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = GiftMziViewModel();
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
      ..init(typeUrl: widget.typeUrl)
      ..error
          .stream
          .where((b) => b)
          .map((_) {
            switch (widget.typeUrl) {
              case "mm":
                return S.of(context).beachGirlFail;
              case "hot":
                return S.of(context).mostHotFail;
              case "taiwan":
                return S.of(context).taiwanGirFail;
              case "xinggan":
                return S.of(context).sexGirlFail;
              case "japan":
                return S.of(context).japanGirlFail;
              default:
                return "";
            }
          })
          .listen(
              (text) => networkError(errorText: text, retry: _viewModel.reload))
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
                  final headers = Map<String, String>();
                  headers["Referer"] = data.refer;

                  return RepaintBoundary(
                    child: GestureDetector(
                      onTap: () =>
                          push(context, page: GiftMziImagePage(data: data)),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: data.width / data.height,
                            child: NetImage(
                              headers: headers,
                              url: data.url,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 6, bottom: 6),
                            child: Icon(
                              Icons.photo_library,
                              color: Colors.white70,
                            ),
                          ),
                        ],
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
