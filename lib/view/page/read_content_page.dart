import 'package:flutter_weather/commom_import.dart';

class ReadContentPage extends StatefulWidget {
  final String typeUrl;

  ReadContentPage({@required this.typeUrl});

  @override
  State createState() => ReadContentState(typeUrl: typeUrl);
}

/// 继承[AutomaticKeepAliveClientMixin]实现页面切换不被清理
class ReadContentState extends PageState<ReadContentPage>
    with AutomaticKeepAliveClientMixin {
  final String typeUrl;
  final _viewModel = ReadViewModel();

  @override
  bool get wantKeepAlive => true;

  ReadContentState({@required this.typeUrl});

  @override
  void initState() {
    super.initState();

    _viewModel.init(typeUrl: typeUrl);
    bindStreamOfViewModel(_viewModel);
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      loadingStream: _viewModel.isLoading.stream,
      child: StreamBuilder(
        stream: _viewModel.datas.stream,
        builder: (context, snapshot) {
          final List<ReadData> datas = snapshot.data ?? List();

          return RefreshIndicator(
            onRefresh: () => _viewModel.loadData(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: const ClampingScrollPhysics()),
              padding: const EdgeInsets.only(),
              itemCount: datas.length,
              itemBuilder: (context, index) {
                debugPrint("index====>$index");

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
    );
  }

  Widget _buildReadItem({@required ReadData data, @required int index}) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: InkWell(
        onTap: () =>
            push(context, page: WebViewPage(title: data.name, url: data.url)),
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
