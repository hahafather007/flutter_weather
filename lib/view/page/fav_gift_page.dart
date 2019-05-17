import 'package:flutter_weather/commom_import.dart';

class FavGiftPage extends StatefulWidget {
  FavGiftPage({Key key}) : super(key: key);

  @override
  State createState() => FavGiftState();
}

/// 继承[MustKeepAliveMixin]实现页面切换不被清理
class FavGiftState extends PageState<FavGiftPage> with MustKeepAliveMixin {
  final _viewModel = FavGiftViewModel();

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
        final List<MziData> datas = snapshot.data ?? [];

        return Stack(
          children: <Widget>[
            // 有内容时的显示
            datas.isNotEmpty
                ? StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: const ClampingScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                    itemCount: datas.length,
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      final data = datas[index];

                      return GestureDetector(
                        onTap: () => push(context,
                            page:
                                GiftGankWatchPage(index: index, photos: datas)),
                        child: AspectRatio(
                          aspectRatio: data.width / data.height,
                          child: Hero(
                            tag: "${data.url}${index}false",
                            child: NetImage(url: data.url),
                          ),
                        ),
                      );
                    },
                  )
                : Container(),

            // 占位
            datas.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppText.of(context).listEmpty,
                      style:
                          TextStyle(fontSize: 16, color: AppColor.colorText3),
                    ),
                  )
                : Container()
          ],
        );
      },
    );
  }
}
