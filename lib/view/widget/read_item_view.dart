import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/model/data/gank_data.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/webview_page.dart';
import 'package:flutter_weather/view/widget/net_image.dart';

/// 闲读的每一条Item
class ReadItemView extends StatelessWidget {
  final GankItem data;

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
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 84),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 标题
                    Text(
                      "${data.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.text1,
                      ),
                    ),

                    // 内容
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

                    // 时间和作者
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

              // 图片
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: NetImage(
                  url: "$img",
                  width: 76,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
