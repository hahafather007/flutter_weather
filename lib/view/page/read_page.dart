import 'package:flutter_weather/commom_import.dart';

class ReadPage extends StatefulWidget {
  final ReadState _state = ReadState();

  @override
  State createState() {
    debugPrint("========>ReadPage");

    return _state;
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    _state.setDrawerOpenFunc(openDrawer: openDrawer);
  }
}

class ReadState extends ReadInter<ReadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppText.of(context).read,
        color: AppColor.colorMain,
        leftBtn: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: openDrawer,
        ),
      ),
      body: Text("闲读"),
    );
  }
}
