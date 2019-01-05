import 'package:flutter_weather/commom_import.dart';

class PhotoWatchPage extends StatefulWidget {
  @override
  State createState() => PhotoWatchState();
}

class PhotoWatchState extends PageState<PhotoWatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemBuilder: (context, index) {
          return ZoomableWidget(
            maxScale: 2,
            child: NetImage(
//                      url: data.url,
              url:
                  "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
            ),
          );
        }, /**/
      ),
    );
  }
}
