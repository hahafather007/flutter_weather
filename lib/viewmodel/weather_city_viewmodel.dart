import 'package:flutter_weather/commom_import.dart';
import 'package:dio/dio.dart';

class WeatherCityViewModel extends ViewModel {
  final int index;

  final _service = WeatherService();

  final weather = StreamController<Weather>();
  final air = StreamController<WeatherAir>();
  final perStatus = StreamController<PermissionStatus>();

  WeatherCityViewModel({@required this.index}) {
    // 首先将缓存的数据作为第一数据显示，再判断请求逻辑
    final mWeather = WeatherHolder().weathers[index];
    final mAir = WeatherHolder().airs[index];
    streamAdd(weather, mWeather);
    streamAdd(air, mAir);

    loadData(isRefresh: false);
  }

  Future<Null> loadData({bool isRefresh = true}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (!isRefresh) {
      streamAdd(isLoading, true);
    }

    District mCity;
    if (index == 0) {
      // 请求定位权限
      final status = (await PermissionHandler().requestPermissions([
        PermissionGroup.locationWhenInUse
      ]))[PermissionGroup.locationWhenInUse];
      streamAdd(perStatus, status);

      if (status != PermissionStatus.denied) {
        final result = await ChannelUtil.getLocation();
        if (result != null) {
          final csv = await rootBundle.loadString("assets/china-city-list.csv");
          final csvList = const CsvToListConverter().convert(csv);
          for (int i = 2; i < csvList.length; i++) {
            final list = csvList[i];
            if (list[2] == result.district && list[7] == result.province) {
              mCity = District(name: result.district, id: list[0]);
              break;
            }
          }
        } else {
          mCity = WeatherHolder().cities[index];
        }
      } else {
        mCity = WeatherHolder().cities[index];
      }
    } else {
      mCity = WeatherHolder().cities[index];
    }

    try {
      final weatherData = await _service.getWeather(city: mCity.id);
      // 储存本次天气结果
      if (weatherData?.weathers?.isNotEmpty ?? false) {
        final mWeather = weatherData.weathers.first;
        streamAdd(weather, mWeather);

        final airData = await _service.getAir(city: mWeather.basic?.parentCity);
        if (airData?.weatherAir?.isNotEmpty ?? false) {
          final mAir = airData.weatherAir.first;
          streamAdd(air, mAir);

          WeatherHolder().addCity(mCity, updateIndex: index);
          WeatherHolder().addWeather(mWeather, updateIndex: index);
          WeatherHolder().addAir(mAir, updateIndex: index);
        }
      }
    } on DioError catch (e) {
      doError(e);
    } finally {
      selfLoading = false;

      if (!isRefresh) {
        streamAdd(isLoading, false);
      }
    }
  }

  @override
  void dispose() {
    _service.dispose();

    weather.close();
    air.close();
    perStatus.close();

    super.dispose();
  }
}
