import 'package:flutter/material.dart';
import 'package:flutter_weather/language.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/view/widget/read_item_view.dart';
import 'package:flutter_weather/viewmodel/read_viewmodel.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class ReadContentPage extends StatefulWidget {
  final String typeUrl;

  ReadContentPage({Key key, @required this.typeUrl}) : super(key: key);

  @override
  State createState() => ReadContentState();
}

class ReadContentState extends PageState<ReadContentPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = ReadViewModel();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _viewModel.init(typeUrl: widget.typeUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String errorText = "";
    switch (widget.typeUrl) {
      case "wow":
        errorText = AppText.of(context).xianduFail;
        break;
      case "apps":
        errorText = AppText.of(context).xianduAppsFail;
        break;
      case "imrich":
        errorText = AppText.of(context).xianduImrichFail;
        break;
      case "funny":
        errorText = AppText.of(context).xianduFunnyFail;
        break;
      case "android":
        errorText = AppText.of(context).xianduAndroidFail;
        break;
      case "diediedie":
        errorText = AppText.of(context).xianduDieFail;
        break;
      case "thinking":
        errorText = AppText.of(context).xianduThinkFail;
        break;
      case "iOS":
        errorText = AppText.of(context).xianduIosFail;
        break;
      case "teamblog":
        errorText = AppText.of(context).xianduBlogFail;
        break;
    }
    bindErrorStream(_viewModel.error.stream,
        errorText: errorText,
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
            final List<ReadData> list = snapshot.data ?? [];

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

                  return ReadItemView(
                    data: list[index],
                    index: index + 1,
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
