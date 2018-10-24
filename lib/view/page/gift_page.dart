import 'package:flutter_weather/commom_import.dart';

class GiftPage extends StatefulWidget {
  final GiftState _state = GiftState();

  @override
  State createState() {
    debugPrint("========>GiftPage");

    return _state;
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    _state.setDrawerOpenFunc(openDrawer: openDrawer);
  }
}

class GiftState extends GirlInter<GiftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppText.of(context).gift,
        color: AppColor.colorMain,
        leftBtn: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: openDrawer,
        ),
      ),
      body: Text("福利"),
    );
  }
}
