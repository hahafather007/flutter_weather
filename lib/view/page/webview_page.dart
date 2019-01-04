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

  WebViewState({@required this.title, @required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
