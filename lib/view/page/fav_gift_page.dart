import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/gift_gank_watch_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/net_image.dart';
import 'package:flutter_weather/viewmodel/fav_gift_viewmodel.dart';

class FavGiftPage extends StatefulWidget {
  FavGiftPage({Key key}) : super(key: key);

  @override
  State createState() => FavGiftState();
}

class FavGiftState extends PageState<FavGiftPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = FavGiftViewModel();

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
      initialData: [],
      builder: (context, snapshot) {
        final List<MziItem> list = snapshot.data;

        return Stack(
          children: <Widget>[
            // 有内容时的显示
            StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const AlwaysScrollableScrollPhysics(
                  parent: const ClampingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
              itemCount: list.length,
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemBuilder: (context, index) {
                final data = list[index];

                return RepaintBoundary(
                  child: GestureDetector(
                    onTap: () => push(context,
                        page: GiftGankWatchPage(index: index, photos: list)),
                    child: AspectRatio(
                      aspectRatio: data.width / data.height,
                      child: Hero(
                        tag: "${data.url}${index}false",
                        child: NetImage(url: data.url),
                      ),
                    ),
                  ),
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
