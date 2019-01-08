import 'package:flutter_weather/commom_import.dart';

class GiftMziImagePage extends StatefulWidget {
  final String link;

  GiftMziImagePage({@required this.link});

  @override
  State createState() => GiftMziImageState(link: link);
}

class GiftMziImageState extends PageState<GiftMziImagePage> {
  final String link;
  final _viewModel = GiftMziImageViewModel();

  GiftMziImageState({@required this.link});

  @override
  void initState() {
    super.initState();

    _viewModel.loadData(link: link);
  }

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
          AppText.of(context).imageSet,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        color: AppColor.colorMain,
        leftBtn: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => pop(context),
        ),
      ),
    );
  }
}
