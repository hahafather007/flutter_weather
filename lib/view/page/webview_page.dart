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

  CustomWebViewState(
      {@required this.title, @required this.url, @required this.favData})
      : _viewModel = WebViewModel(favData: favData);

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
    );
  }
}
