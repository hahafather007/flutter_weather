import 'package:flutter_weather/commom_import.dart';

class GiftMziPage extends StatefulWidget {
  @override
  State createState() => GiftMziState();
}

class GiftMziState extends PageState<GiftMziPage> {
  GiftMziViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = GiftMziViewModel()..init();
  }

  @override
  void dispose() {
    super.dispose();

    _viewModel?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingView(
        key: loadingKey,
        child: StreamBuilder(
          stream: _viewModel.datas.stream,
          builder: (context, snapshot) {
            final List<MziData> datas = snapshot.data ?? List();

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
                    final data = datas[index];
                    final headers = Map<String, String>();
                    headers["Referer"] = data.refer;

                    return NetImage(
                      headers: headers,
                      url: "",
                      height: null,
                      width: null,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
