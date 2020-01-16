import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/language.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/webview_page.dart';
import 'package:flutter_weather/view/widget/net_image.dart';
import 'package:flutter_weather/viewmodel/fav_read_viewmodel.dart';

class FavReadPage extends StatefulWidget {
  FavReadPage({Key key}) : super(key: key);

  @override
  State createState() => FavReadState();
}

class FavReadState extends PageState<FavReadPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = FavReadViewModel();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: _viewModel.data.stream,
      builder: (context, snapshot) {
        final List<ReadData> list = snapshot.data ?? [];

        return Stack(
          children: <Widget>[
            // 有内容时的显示
            ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: const ClampingScrollPhysics()),
              padding: const EdgeInsets.only(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key("Dismissible${list[index].url}"),
                  child: _buildReadItem(data: list[index], index: index + 1),
                  onDismissed: (_) => _viewModel.removeRead(list[index]),
                );
              },
            ),

            // 占位
            list.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppText.of(context).listEmpty,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.text3,
                      ),
                    ),
                  )
                : Container()
          ],
        );
      },
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
                          TextStyle(fontSize: 16, color: AppColor.text1),
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
                            TextStyle(fontSize: 12, color: AppColor.text2),
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
