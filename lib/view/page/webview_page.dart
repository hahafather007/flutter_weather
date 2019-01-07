import 'package:flutter_weather/commom_import.dart';

class CustomWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  CustomWebViewPage({@required this.title, @required this.url});

  @override
  State createState() => CustomWebViewState(title: title, url: url);
}

class CustomWebViewState extends PageState<CustomWebViewPage> {
  final String title;
  final String url;

  CustomWebViewState({@required this.title, @required this.url});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
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
          IconButton(
            icon: Icon(
              Icons.open_in_new,
              color: Colors.white,
            ),
            onPressed: () => openBrowser(url),
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () => Share.share("$title\n$url"),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () => Clipboard.setData(ClipboardData(text: url)),
          ),
        ],
      ),
    );
  }
}
