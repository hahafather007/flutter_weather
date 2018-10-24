import 'package:flutter_weather/commom_import.dart';

class WeatherPage extends StatefulWidget {
  final WeatherState _state = WeatherState();

  @override
  State createState() {
    debugPrint("========>WeatherPage");

    return _state;
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    _state.setDrawerOpenFunc(openDrawer: openDrawer);
  }
}

class WeatherState extends WeatherInter<WeatherPage> {
  WeatherPresenter _presenter;

  @override
  void initState() {
    super.initState();

    debugPrint("init========>WeatherState");

    _presenter = WeatherPresenter(this);
    DefaultAssetBundle.of(context)
        .loadString("jsons/weather_map.json")
        .then(debugPrint);
  }

  @override
  void dispose() {
    super.dispose();

    _presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _presenter.city,
        color: Colors.lightBlueAccent,
        leftBtn: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: openDrawer,
        ),
        rightBtns: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: LoadingView(
        _presenter.isLoading,
        child: RefreshIndicator(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: false,
            enableOverScroll: false,
            child: ListView(),
          ),
          onRefresh: () => _presenter.refresh(),
        ),
      ),
    );
  }
}
