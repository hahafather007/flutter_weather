import 'package:flutter_weather/commom_import.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  WebViewPage({@required this.title, @required this.url});

  @override
  State createState() => WebViewState(title: title, url: url);
}

class WebViewState extends PageState<WebViewPage> {
  final String title;
  final String url;
  final _loadStream = StreamController<bool>();

  WebViewController _controller;

  WebViewState({@required this.title, @required this.url});

  @override
  void dispose() {
    _loadStream.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 0, child: Text(AppText.of(context).refresh)),
                  PopupMenuItem(
                      value: 1, child: Text(AppText.of(context).share)),
                  PopupMenuItem(
                      value: 2, child: Text(AppText.of(context).copyUrl)),
                  PopupMenuItem(
                      value: 3, child: Text(AppText.of(context).openByOther)),
                ],
            onSelected: (int index) {
              switch (index) {
                case 0:
                  _controller?.reload();
                  break;
                case 1:
                  Share.share("$title\n$url");
                  break;
                case 2:
                  Clipboard.setData(ClipboardData(text: url));
                  showToast(AppText.of(context).alreadyCopyUrl);
                  break;
                case 3:
                  openBrowser(url);
                  break;
              }
            },
          ),
        ],
      ),
      body: LoadingView(
        loadingStream: _loadStream.stream,
        child: WebView(
          onWebViewCreated: (controller) {
            _controller = controller;
            _loadStream.add(true);
            controller.loadUrl(url).then((_) => _loadStream.add(false));
          },
        ),
      ),
    );
  }
}
