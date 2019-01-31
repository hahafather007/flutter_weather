import 'package:flutter_weather/commom_import.dart';

class CustomWebViewPage<T> extends StatefulWidget {
  final String title;
  final String url;

  /// 收藏时保存在本地的数据
  final T favData;

  CustomWebViewPage(
      {@required this.title, @required this.url, @required this.favData});

  @override
  State createState() =>
      CustomWebViewState(title: title, url: url, favData: favData);
}

class CustomWebViewState<T> extends PageState<CustomWebViewPage> {
  final String title;
  final String url;
  final T favData;
  final WebViewModel _viewModel;

  WebVuwController _controller;

  CustomWebViewState(
      {@required this.title, @required this.url, @required this.favData})
      : _viewModel = WebViewModel(favData: favData);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.stopLoading();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        color: AppColor.colorMain,
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
                  Share.share("$title\n$url");
                  break;
                case "copy":
                  Clipboard.setData(ClipboardData(text: url));
                  showToast(AppText.of(context).alreadyCopyUrl);
                  break;
                case "openByOther":
                  openBrowser(url);
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
                onPressed: () => FavHolder().autoFav(favData),
              );
            },
          ),
        ],
      ),
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: WebVuw(
          initialUrl: url,
          pullToRefresh: false,
          enableJavascript: false,
          onWebViewCreated: (controller) {
            _controller = controller;
            _viewModel.bindEvent(controller.onEvents());
          },
        ),
      ),
    );
  }
}
