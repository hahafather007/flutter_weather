import 'package:flutter/material.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/gank_data.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/view/widget/read_item_view.dart';
import 'package:flutter_weather/viewmodel/gank_viewmodel.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class ReadContentPage extends StatefulWidget {
  final GankTitle title;

  ReadContentPage({Key key, @required this.title}) : super(key: key);

  @override
  State createState() => ReadContentState();
}

class ReadContentState extends PageState<ReadContentPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = GankViewModel();
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
      ..init(category: "Article",type: widget.title.type)
      ..error
          .stream
          .where((b) => b)
          .listen((_) => networkError(
              errorText: S.of(context).readLoadFail(widget.title.title),
              retry: _viewModel.reload))
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
            final List<GankItem> list = snapshot.data?.data ?? [];

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(type: LoadType.REFRESH),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: const ClampingScrollPhysics()),
                padding: const EdgeInsets.only(),
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    ReadItemView(data: list[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
