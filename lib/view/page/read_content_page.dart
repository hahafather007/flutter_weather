import 'package:flutter/material.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/view/widget/read_item_view.dart';
import 'package:flutter_weather/viewmodel/read_content_viewmodel.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class ReadContentPage extends StatefulWidget {
  final ReadTitle title;

  ReadContentPage({Key key, @required this.title}) : super(key: key);

  @override
  State createState() => ReadContentState();
}

class ReadContentState extends PageState<ReadContentPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = ReadContentViewModel();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _viewModel.init(type: widget.title.type);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bindErrorStream(_viewModel.error.stream,
        errorText: S.of(context).readLoadFail(widget.title.title),
        retry: () => _viewModel.loadData(type: LoadType.NEW_LOAD));
  }

  @override
  void dispose() {
    _viewModel.dispose();

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
            final List<ReadItem> list = snapshot.data ?? [];

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(type: LoadType.REFRESH),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: const ClampingScrollPhysics()),
                padding: const EdgeInsets.only(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  // 在倒数第5个item显示时就加载下一页
                  if (index + 1 >= list.length - 5) {
                    _viewModel.loadMore();
                  }

                  return ReadItemView(data: list[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
