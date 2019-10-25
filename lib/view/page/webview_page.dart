import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/language.dart';
import 'package:flutter_weather/model/holder/fav_holder.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/viewmodel/web_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController _controller;

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
            onPressed: () async {
              if (_controller != null && await _controller.canGoBack()) {
                _controller.goBack();
              } else {
                pop(context);
              }
            },
          ),
          rightBtns: [
            widget.favData != null
                ? StreamBuilder(
                    stream: _viewModel.isFav.stream,
                    builder: (context, snapshot) {
                      final isFav = snapshot.data ?? false;

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
                  child: Text(AppText.of(context).refresh),
                ),
                PopupMenuItem(
                  value: "share",
                  child: Text(AppText.of(context).share),
                ),
                PopupMenuItem(
                  value: "copy",
                  child: Text(AppText.of(context).copyUrl),
                ),
                PopupMenuItem(
                  value: "openByOther",
                  child: Text(AppText.of(context).openByOther),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case "refresh":
                    _controller?.reload();
                    break;
                  case "share":
                    Share.text(AppText.of(context).share,
                        "${widget.title}\n${widget.url}", "text/plain");
                    break;
                  case "copy":
                    Clipboard.setData(ClipboardData(text: widget.url));
                    showSnack(text: AppText.of(context).alreadyCopyUrl);
                    break;
                  case "openByOther":
                    openBrowser(widget.url);
                    break;
                }
              },
            ),
          ],
        ),
        body: LoadingView(
          loadingStream: _viewModel.isLoading.stream,
          child: WebView(
            initialUrl: "${widget.url}",
            onWebViewCreated: (controller) => _controller = controller,
            onPageFinished: (_) => _viewModel.setLoading(false),
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
      onWillPop: () async {
        if (_controller != null && await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          pop(context);
        }

        return false;
      },
    );
  }
}
