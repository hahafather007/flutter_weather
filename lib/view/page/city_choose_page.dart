import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/city_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';

class CityChoosePage extends StatefulWidget {
  @override
  State createState() => CityChooseState();
}

class CityChooseState extends PageState<CityChoosePage> {
  final _csvList = List<List<dynamic>>();

  String _province;
  String _city;

  @override
  void dispose() {
    _csvList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          S.of(context).cityChoose,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        color: Theme.of(context).accentColor,
        leftBtn: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => pop(context),
        ),
      ),
      body: Row(
        children: <Widget>[
          // 省
          Expanded(
            child: FutureBuilder(
              future: _getProvinces(),
              initialData: [],
              builder: (context, snapshot) {
                final List<String> provinces = snapshot.data;

                return ListView.builder(
                  itemCount: provinces.length,
                  padding: const EdgeInsets.only(),
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final province = provinces[index];

                    return _buildItem(
                      name: province,
                      isSelect: province == _province,
                      onTap: () => setState(() {
                        if (province != _province) {
                          _province = province;
                          _city = null;
                        }
                      }),
                    );
                  },
                );
              },
            ),
          ),
          Container(width: 1, color: AppColor.line2),

          // 市
          Expanded(
            child: FutureBuilder(
              future: _getCities(),
              initialData: [],
              builder: (context, snapshot) {
                final List<String> cities = snapshot.data;

                return ListView.builder(
                  itemCount: cities.length,
                  padding: const EdgeInsets.only(),
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final city = cities[index];

                    return _buildItem(
                      name: city,
                      isSelect: city == _city,
                      onTap: () => setState(() {
                        _city = city;
                      }),
                    );
                  },
                );
              },
            ),
          ),
          Container(width: 1, color: AppColor.line2),

          // 县
          Expanded(
            child: FutureBuilder(
              future: _getDistricts(),
              initialData: [],
              builder: (context, snapshot) {
                final List<District> districts = snapshot.data;

                return ListView.builder(
                  itemCount: districts.length,
                  padding: const EdgeInsets.only(),
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final district = districts[index];

                    return _buildItem(
                      name: district.name,
                      isSelect: false,
                      onTap: () => pop(context, extraData: district),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建选项部件
  Widget _buildItem(
      {@required String name,
      @required bool isSelect,
      @required VoidCallback onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: 40,
          color: isSelect ? Theme.of(context).accentColor : Colors.transparent,
          child: Column(
            children: <Widget>[
              Container(height: 1, color: AppColor.line3),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: AppColor.text1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取省列表
  Future<List<String>> _getProvinces() async {
    final provinces = List<String>();
    if (_csvList.isEmpty) {
      final csv = await DefaultAssetBundle.of(context)
          .loadString("assets/china-city-list.csv");
      _csvList.addAll(const CsvToListConverter().convert(csv));
    }
    for (int i = 2; i < _csvList.length; i++) {
      final list = _csvList[i];
      final name = list[7];
      if (!provinces.contains(name)) {
        provinces.add(name);
      }
    }

    return provinces;
  }

  /// 获取市列表
  Future<List<String>> _getCities() async {
    if (_province == null) {
      return [];
    }

    final cities = List<String>();
    for (int i = 2; i < _csvList.length; i++) {
      final list = _csvList[i];
      if (list[7] == _province) {
        final name = list[9];
        if (!cities.contains(name)) {
          cities.add(name);
        }
      } else if (cities.isNotEmpty) {
        break;
      }
    }

    return cities;
  }

  /// 获取区列表
  Future<List<District>> _getDistricts() async {
    if (_city == null) {
      return [];
    }

    final districts = List<District>();
    for (int i = 2; i < _csvList.length; i++) {
      final list = _csvList[i];
      if (list[7] == _province && list[9] == _city) {
        districts.add(District(name: list[2], id: list[0]));
      } else if (districts.isNotEmpty) {
        break;
      }
    }

    return districts;
  }
}
