import 'package:flutter_weather/commom_import.dart';

class GiftMziPage extends StatefulWidget {
  @override
  State createState() => GiftMziState();
}

class GiftMziState extends PageState<GiftMziPage> {
  GiftMziViewModel presenter;

  @override
  void initState() {
    super.initState();

    presenter = GiftMziViewModel()..loadData();
  }

  @override
  void dispose() {
    super.dispose();

    presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
