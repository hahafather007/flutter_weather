import 'package:flutter_weather/commom_import.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    SharedDepository()
        .initShared()
        .then((_) => push(context, page: HomePage(), replace: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
