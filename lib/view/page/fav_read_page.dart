import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/read_item_view.dart';
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
      stream: _viewModel.items.stream,
      builder: (context, snapshot) {
        final List<ReadItem> list = snapshot.data ?? [];

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
                  key: Key("Dismissible${list[index].sId}"),
                  onDismissed: (_) => _viewModel.removeRead(list[index]),
                  child: ReadItemView(data: list[index]),
                );
              },
            ),

            // 占位
            list.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).listEmpty,
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
}
