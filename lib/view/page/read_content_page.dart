import 'package:flutter_weather/commom_import.dart';

class ReadContentPage extends StatefulWidget {
  @override
  State createState() => ReadContentState();
}

/// 继承[AutomaticKeepAliveClientMixin]实现页面切换不被清理
class ReadContentState extends PageState<ReadContentPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = ReadViewModel();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _viewModel.init();
    _viewModel.error.stream.listen((_) => networkError());
    _viewModel.isLoading.stream.listen((loading) {
      if (loading) {
        loadingKey.currentState.show();
      } else {
        loadingKey.currentState.dismiss();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorRead,
      body: LoadingView(
        key: loadingKey,
        child: StreamBuilder(
          stream: _viewModel.datas.stream,
          builder: (context, snapshot) {
            final List<ReadData> datas = snapshot.data ?? List();

            return RefreshIndicator(
              onRefresh: () => _viewModel.loadData(),
              child: SmartRefresher(
                enablePullUp: false,
                enableOverScroll: false,
                enablePullDown: false,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(),
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    return _buildReadItem(data: datas[index]);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadItem({@required ReadData data}) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(),
          ),
          Container(
            width: 120,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: NetImage(
              url: data.icon,
              height: 35,
              width: 35,
              isCircle: true,
            ),
          ),
        ],
      ),
    );
  }
}
