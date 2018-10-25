import 'package:flutter_weather/commom_import.dart';

class GiftMziPage extends StatefulWidget {
  @override
  State createState() => GiftMziState();
}

class GiftMziState extends GiftMziInter<GiftMziPage> {
  GiftMziPresenter presenter;

  @override
  void initState() {
    super.initState();

    presenter = GiftMziPresenter(this)..loadData();
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
