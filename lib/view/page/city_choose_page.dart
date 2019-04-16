import 'package:flutter_weather/commom_import.dart';

class CityChoosePage extends StatefulWidget {
  @override
  State createState() => CityChooseState();
}

class CityChooseState extends PageState<CityChoosePage> {
  String _provinceId;
  String _cityId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          AppText.of(context).cityChoose,
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
              builder: (context, snapshot) {
                final List<Province> provinces = snapshot.data ?? List();

                return ListView.builder(
                  itemCount: provinces.length,
                  padding: const EdgeInsets.only(),
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final province = provinces[index];

                    return _buildItem(
                      name: province.name,
                      isSelect: province.id == _provinceId,
                      onTap: () => setState(() => _provinceId = province.id),
                    );
                  },
                );
              },
            ),
          ),
          Container(width: 1, color: AppColor.colorLine2),

          // 市
          Expanded(
            child: FutureBuilder(
              future: _getCities(),
              builder: (context, snapshot) {
                final List<City> cities = snapshot.data ?? List();

                return ListView.builder(
                  itemCount: cities.length,
                  padding: const EdgeInsets.only(),
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final city = cities[index];

                    return _buildItem(
                      name: city.name,
                      isSelect: city.id == _cityId,
                      onTap: () => setState(() => _cityId = city.id),
                    );
                  },
                );
              },
            ),
          ),
          Container(width: 1, color: AppColor.colorLine2),

          // 县
          Expanded(
            child: FutureBuilder(
              future: _getDistricts(),
              builder: (context, snapshot) {
                final List<District> districts = snapshot.data ?? List();

                return ListView.builder(
                  itemCount: districts.length,
                  padding: const EdgeInsets.only(),
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final district = districts[index];

                    return _buildItem(
                      name: district.name,
                      isSelect: false,
                      onTap: () => pop(context, extraData: district.name),
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
      @required Function onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: 40,
          color: isSelect ? Theme.of(context).accentColor : Colors.transparent,
          child: Column(
            children: <Widget>[
              Container(height: 1, color: AppColor.colorLine3),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: AppColor.colorText1),
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
  Future<List<Province>> _getProvinces() async {
    final str =
        await DefaultAssetBundle.of(context).loadString("jsons/province.json");
    return (jsonDecode(str) as List).map((v) => Province.fromJson(v)).toList();
  }

  /// 获取市列表
  Future<List<City>> _getCities() async {
    if (_provinceId == null) return null;

    final str =
        await DefaultAssetBundle.of(context).loadString("jsons/city.json");
    return (jsonDecode(str)[_provinceId] as List)
        .map((v) => City.fromJson(v))
        .toList();
  }

  /// 获取区列表
  Future<List<District>> _getDistricts() async {
    if (_cityId == null) return null;

    final str =
        await DefaultAssetBundle.of(context).loadString("jsons/district.json");
    return (jsonDecode(str)[_cityId] as List)
        .map((v) => District.fromJson(v))
        .toList();
  }
}
