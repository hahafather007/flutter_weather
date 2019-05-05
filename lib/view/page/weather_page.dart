import 'package:flutter_weather/commom_import.dart';

class WeatherPage extends StatefulWidget {
  @override
  State createState() => WeatherState();
}

class WeatherState extends PageState<WeatherPage> {
  final _viewModel = WeatherViewModel();
  final _controller = PageController();
  final _pageStream = StreamController<double>();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() => streamAdd(_pageStream, _controller.page));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _controller.dispose();
    _pageStream.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _viewModel.weatherType.stream,
      builder: (context, snapshot) {
        final type = snapshot.data ?? "";

        return StreamBuilder(
          stream: _viewModel.cities.stream,
          builder: (context, snapshot) {
            final List<String> cities = snapshot.data ?? [];

            return StreamBuilder(
              stream: _pageStream.stream,
              builder: (context, snapshot) {
                final double pageValue = snapshot.data ?? 0;

                return Scaffold(
                  key: scafKey,
                  appBar: CustomAppBar(
                    title: Text(
                      cities.isNotEmpty
                          ? cities[min(cities.length - 1, pageValue.round())]
                          : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    color: _getAppBarColor(type: type),
                    showShadow: false,
                    leftBtn: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () => EventSendHolder()
                          .sendEvent(tag: "homeDrawerOpen", event: true),
                    ),
                    rightBtns: [
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: "share",
                                child: Text(AppText.of(context).share),
                              ),
                              PopupMenuItem(
                                value: "cities",
                                child: Text(AppText.of(context).cityControl),
                              ),
                              PopupMenuItem(
                                value: "weathers",
                                child: Text(AppText.of(context).weathersView),
                              ),
                            ],
                        onSelected: (value) {
                          switch (value) {
                            case "share":
                              break;
                            case "cities":
                              push(context, page: CityControlPage());
                              break;
                            case "weathers":
                              _showWeathersDialog();
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                  body: WeatherView(
                    type: type,
                    color: _getAppBarColor(type: type),
                    child: PageView.builder(
                      itemCount: cities.length,
                      controller: _controller,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (index) => _viewModel.indexChange(index),
                      itemBuilder: (context, index) {
                        return Opacity(
                          opacity: 1 - (pageValue - index).abs() % 1,
                          child: WeatherCityPage(
                            key: Key("WeatherCityPage${cities[index]}"),
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// 获取Appbar的颜色
  Color _getAppBarColor({@required String type}) {
    final isDay = DateTime.now().hour >= 6 && DateTime.now().hour < 18;

    if (type.contains("晴") || type.contains("多云")) {
      return isDay ? const Color(0xFF51C0F8) : const Color(0xFF7F9EE9);
    } else if (type.contains("雨")) {
      if (type.contains("雪")) {
        return const Color(0XFF5697D8);
      } else {
        return const Color(0xFF7187DB);
      }
    } else if (type.contains("雪")) {
      return const Color(0xFF62B1FF);
    } else if (type.contains("冰雹")) {
      return const Color(0xFF0CB399);
    } else if (type.contains("霾")) {
      return const Color(0xFF7F8195);
    } else if (type.contains("沙")) {
      return const Color(0xFFE99E3C);
    } else if (type.contains("雾")) {
      return const Color(0xFF8CADD3);
    } else if (type.contains("阴")) {
      return const Color(0xFF6D8DB1);
    } else {
      return isDay ? const Color(0xFF51C0F8) : const Color(0xFF7F9EE9);
    }
  }

  /// 动态天气预览弹窗
  void _showWeathersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              AppText.of(context).weathersView,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            contentPadding: const EdgeInsets.only(),
            titlePadding: const EdgeInsets.fromLTRB(20, 18, 0, 10),
            content: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(),
                children: <Widget>[
                  _buildDialogItem(title: AppText.of(context).sunny),
                  _buildDialogItem(title: AppText.of(context).cloudy),
                  _buildDialogItem(title: AppText.of(context).overcast),
                  _buildDialogItem(title: AppText.of(context).rain),
                  _buildDialogItem(title: AppText.of(context).flashRain),
                  _buildDialogItem(title: AppText.of(context).snowRain),
                  _buildDialogItem(title: AppText.of(context).snow),
                  _buildDialogItem(title: AppText.of(context).hail),
                  _buildDialogItem(title: AppText.of(context).fog),
                  _buildDialogItem(title: AppText.of(context).smog),
                  _buildDialogItem(title: AppText.of(context).sandstorm),
                ],
              ),
            ),
          ),
    );
  }

  /// 动态天气预览的选项
  Widget _buildDialogItem({@required String title}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          pop(context);
          _viewModel.switchType(title);
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Icon(
                  Icons.panorama_fish_eye,
                  color: Colors.black54,
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
