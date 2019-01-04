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

class GiftState extends PageState<GiftPage> {
  Function openDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          AppText.of(context).gift,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        color: AppColor.colorMain,
        leftBtn: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: openDrawer,
        ),
      ),
      body: GiftMziPage(),
    );
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    this.openDrawer = openDrawer;
  }
}
