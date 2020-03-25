import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/gift_mzi_image_page.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/net_image.dart';
import 'package:flutter_weather/viewmodel/fav_gifts_viewmodel.dart';

class FavGiftsPage extends StatefulWidget {
  FavGiftsPage({Key key}) : super(key: key);

  @override
  State createState() => FavGiftsState();
}

class FavGiftsState extends PageState<FavGiftsPage>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = FavGiftsViewModel();

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
        final List<MziData> list = snapshot.data ?? [];

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
                final headers = Map<String, String>();
                headers["Referer"] = data.refer;

                return RepaintBoundary(
                  child: GestureDetector(
                    onTap: () =>
                        push(context, page: GiftMziImagePage(data: data)),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: data.width / data.height,
                          child: NetImage(
                            headers: headers,
                            url: data.url,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 6, bottom: 6),
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.white70,
                          ),
                        ),
                      ],
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
