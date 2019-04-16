import 'package:flutter_weather/commom_import.dart';

class CityControlPage extends StatefulWidget {
  @override
  State createState() => CityControlState();
}

class CityControlState extends PageState<CityControlPage> {
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
            onPressed: () => push(context, page: CityChoosePage()),
          ),
        ],
      ),
    );
  }
}
