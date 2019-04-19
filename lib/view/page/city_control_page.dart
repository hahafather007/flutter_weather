import 'package:flutter_weather/commom_import.dart';

class CityControlPage extends StatefulWidget {
  @override
  State createState() => CityControlState();
}

class CityControlState extends PageState<CityControlPage> {
  final _viewModel = CityControlViewModel();

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          AppText.of(context).cityControl,
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
        rightBtns: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              push(context, page: CityChoosePage()).then((location) {
                if (location == null) return;

                _viewModel.addCity(location);
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _viewModel.locations.stream,
        builder: (context, snapshot) {
          final List<Location> cities = snapshot.data ?? List();

          return StreamBuilder(
            stream: _viewModel.weathers.stream,
            builder: (context, snapshot) {
              final List<Weather> weathers = snapshot.data ?? List();

              return DragAndDropList(
                cities.length,
                canBeDraggedTo: (oldIndex, _) => false,
                itemBuilder: (context, index) {
                  return _buildCityItem(
                    city: cities[index].district,
                    data: weathers[index],
                    isFirst: index == 0,
                  );
                },
                onDragFinish: (before, after) {},
              );
            },
          );
        },
      ),
    );
  }

  /// 城市列表Item
  Widget _buildCityItem(
      {@required String city,
      @required Weather data,
      @required bool isFirst}) {
    final now = data?.now;

    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          children: <Widget>[
            Text(
              city,
              style: TextStyle(fontSize: 18, color: AppColor.colorText1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: isFirst
                  ? Icon(
                      Icons.location_on,
                      color: Theme.of(context).accentColor,
                    )
                  : Container(),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        now?.condTxt ?? AppText.of(context).unknown,
                        style:
                            TextStyle(fontSize: 12, color: AppColor.colorText1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          now?.tmp != null
                              ? "${now.tmp}℃"
                              : AppText.of(context).unknown,
                          style: TextStyle(
                              fontSize: 12, color: AppColor.colorText1),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Image.asset(
                      "images/${now?.condCode ?? 100}.png",
                      height: 32,
                      width: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
