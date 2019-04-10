import 'package:flutter_weather/commom_import.dart';

class ReadContentPage extends StatefulWidget {
  final String typeUrl;

  ReadContentPage({Key key, @required this.typeUrl}) : super(key: key);

  @override
  State createState() => ReadContentState();
}

/// 继承[MustKeepAliveMixin]实现页面切换不被清理
class ReadContentState extends PageState<ReadContentPage>
    with MustKeepAliveMixin {
  final _viewModel = ReadViewModel();

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
    return Scaffold(
      key: scafKey,
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.data.stream,
          builder: (context, snapshot) {
            final List<ReadData> datas = snapshot.data ?? List();

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(type: LoadType.REFRESH),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: const ClampingScrollPhysics()),
                padding: const EdgeInsets.only(),
                itemCount: datas.length,
                itemBuilder: (context, index) {
                  // 在倒数第5个item显示时就加载下一页
                  if (index + 1 >= datas.length - 5) {
                    _viewModel.loadMore();
                  }

                  return _buildReadItem(data: datas[index], index: index + 1);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadItem({@required ReadData data, @required int index}) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: InkWell(
        onTap: () => push(context,
            page: CustomWebViewPage(
                title: data.name, url: data.url, favData: data)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$index. ${data.name}",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, color: AppColor.colorText1),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: data.updateTime),
                          TextSpan(
                              text: " · ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: data.from),
                        ],
                        style:
                            TextStyle(fontSize: 12, color: AppColor.colorText2),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 68,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 6),
                child: NetImage(
                  url: data.icon,
                  height: 40,
                  width: 40,
                  isCircle: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
