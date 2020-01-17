import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/webview_page.dart';
import 'package:flutter_weather/view/widget/net_image.dart';

/// 闲读的每一条Item
class ReadItemView extends StatelessWidget {
  final ReadData data;
  final int index;

  ReadItemView({@required this.data, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: InkWell(
        onTap: () => push(context,
            page: CustomWebViewPage(
                title: data.name, url: data.url, favData: data)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$index. ${data.name}",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, color: AppColor.text1),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: data.updateTime),
                          TextSpan(
                              text: " · ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: data.from),
                        ],
                        style: TextStyle(fontSize: 12, color: AppColor.text2),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 68,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 6),
                child: NetImage(
                  url: data.icon,
                  height: 40,
                  width: 40,
                  isCircle: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
