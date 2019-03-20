import 'package:flutter_weather/commom_import.dart';

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
  WebVuwController _controller;

  @override
  void initState() {
    super.initState();

    _viewModel = WebViewModel(favData: widget.favData);
  }

  @override
  void dispose() {
    _controller.stopLoading();
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        color: Theme.of(context).accentColor,
        leftBtn: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () => pop(context),
        ),
        rightBtns: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (context) => <PopupMenuEntry>[
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
                  Share.share("${widget.title}\n${widget.url}");
                  break;
                case "copy":
                  Clipboard.setData(ClipboardData(text: widget.url));
                  scafKey.currentState.showSnackBar(SnackBar(
                      content: Text(AppText.of(context).alreadyCopyUrl),
                      duration: Duration(milliseconds: 2500)));
                  break;
                case "openByOther":
                  openBrowser(widget.url);
                  break;
              }
            },
          ),
          StreamBuilder(
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
          ),
        ],
      ),
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: WebVuw(
          initialUrl: widget.url,
          pullToRefresh: false,
          enableJavascript: true,
          onWebViewCreated: (controller) {
            _controller = controller;
            _viewModel.bindEvent(controller.onEvents());
          },
        ),
      ),
    );
  }
}
