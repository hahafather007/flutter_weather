import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';
import 'package:flutter_weather/viewmodel/web_viewmodel.dart';

class CustomWebViewPage<T> extends StatefulWidget {
  final String title;
  final String url;

  /// 收藏时保存在本地的数据
  final T favData;

  CustomWebViewPage(
      {@required this.title, @required this.url, @required this.favData});

  @override
  State createState() => CustomWebViewState();
}

class CustomWebViewState<T> extends PageState<CustomWebViewPage> {
  WebViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = WebViewModel(favData: widget.favData);
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: scafKey,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          color: Theme.of(context).accentColor,
          leftBtn: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => pop(context),
          ),
          rightBtns: [
            widget.favData != null
                ? StreamBuilder(
                    stream: _viewModel.isFav.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      final isFav = snapshot.data;

                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () => FavHolder().autoFav(widget.favData),
                      );
                    },
                  )
                : Container(),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "refresh",
                  child: Text(S.of(context).refresh),
                ),
                PopupMenuItem(
                  value: "share",
                  child: Text(S.of(context).share),
                ),
                PopupMenuItem(
                  value: "copy",
                  child: Text(S.of(context).copyUrl),
                ),
                PopupMenuItem(
                  value: "openByOther",
                  child: Text(S.of(context).openByOtherWay),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case "refresh":
                    break;
                  case "share":
                    break;
                  case "copy":
                    Clipboard.setData(ClipboardData(text: widget.url));
                    showSnack(text: S.of(context).alreadyCopyUrl);
                    break;
                  case "openByOther":
                    break;
                }
              },
            ),
          ],
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
