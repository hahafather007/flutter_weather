import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/webview_page.dart';
import 'package:flutter_weather/view/widget/net_image.dart';

/// 闲读的每一条Item
class ReadItemView extends StatelessWidget {
  final ReadItem data;

  ReadItemView({@required this.data});

  @override
  Widget build(BuildContext context) {
    final img = data.images?.firstWhere((v) => v != null, orElse: () => null);

    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: InkWell(
        onTap: () => push(context,
            page: CustomWebViewPage(
                title: data.title, url: data.url, favData: data)),
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
                      "${data.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.text1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "${data.desc}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.text2,
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: data.publishedAt.substring(0, 10)),
                          TextSpan(
                            text: " · ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: data.author),
                        ],
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColor.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: NetImage(
                  url: "$img",
                  width: 76,
                  height: 76,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
