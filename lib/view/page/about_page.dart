import 'package:flutter_weather/commom_import.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => AboutState();
}

class AboutState extends PageState<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
//            CustomAppBar(
//              title: Text(
//                AppText.of(context).about,
//                overflow: TextOverflow.ellipsis,
//                style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 16,
//                ),
//              ),
//              color: Theme.of(context).accentColor,
//              leftBtn: IconButton(
//                icon: Icon(
//                  Icons.clear,
//                  color: Colors.white,
//                ),
//                onPressed: () => pop(context),
//              ),
//            ),
            SliverAppBar(
              title: Text(
                AppText.of(context).about,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Text("123"),
          ],
        ),
      ),
    );
  }
}
