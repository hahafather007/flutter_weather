import 'package:flutter_weather/commom_import.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() => SettingState();
}

class SettingState extends SettingInter<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Setting"),
    );
  }
}
