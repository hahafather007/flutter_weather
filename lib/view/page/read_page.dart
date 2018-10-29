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

class ReadState extends PageState<ReadPage> {
  Function openDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          AppText.of(context).read,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
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
      body: Text("闲读"),
    );
  }

  void setDrawerOpenFunc({@required Function openDrawer}) {
    this.openDrawer = openDrawer;
  }
}
