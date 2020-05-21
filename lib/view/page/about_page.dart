import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';

import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/webview_page.dart';
import 'package:flutter_weather/view/widget/net_image.dart';

class AboutPage extends StatefulWidget {
  static const photoUrls = [
    "http://cdn.liyuyu.cn/fakeweathers1.png",
    "http://cdn.liyuyu.cn/fakeweathers2.png",
    "http://cdn.liyuyu.cn/fakeweathers3.png",
    "http://cdn.liyuyu.cn/fakeweathers4.png",
    "http://cdn.liyuyu.cn/fakeweathers5.png",
  ];

  @override
  State createState() => AboutState();
}

class AboutState extends PageState<AboutPage> {
  final String _url;
  final _controller = ScrollController();
  final _paddingStream = StreamController<double>();

  AboutState() : _url = AboutPage.photoUrls[Random().nextInt(4)];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      var offset = _controller.offset;
      if (offset > 144) {
        offset = 144;
      }

      _paddingStream.safeAdd(offset / 2);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _paddingStream.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafKey,
      body: NestedScrollView(
        controller: _controller,
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              pinned: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => pop(context),
              ),
              backgroundColor: Theme.of(context).accentColor,
              flexibleSpace: StreamBuilder(
                stream: _paddingStream.stream,
                builder: (context, snapshot) {
                  return FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding:
                        EdgeInsets.only(left: snapshot.data ?? 0.0, bottom: 13),
                    title: Text(
                      S.of(context).about,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity((snapshot.data ?? 0.0) / 72),
                        fontSize: 20,
                      ),
                    ),
                    background: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: NetImage(
                            url: _url,
                            placeholder: Container(),
                          ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.only(),
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            // 版本和名称
            _buildAppName(),

            _buildLine(),

            // 概述
            _buildTitle(title: S.of(context).overview),

            // 项目主页
            _buildOverviewItem(
              icon: Icons.home,
              text: S.of(context).programHome,
              onTap: () => push(context,
                  page: CustomWebViewPage(
                      title: S.of(context).appName,
                      url: "https://github.com/hahafather007/flutter_weather",
                      favData: null)),
            ),

            // 意见反馈
            _buildOverviewItem(
              icon: Icons.feedback,
              text: S.of(context).feedback,
              onTap: () => push(context,
                  page: CustomWebViewPage(
                      title: S.of(context).appName,
                      url:
                          "https://github.com/hahafather007/flutter_weather/issues/new",
                      favData: null)),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildLine(),
            ),

            // 感谢
            _buildTitle(title: S.of(context).thanks),

            // 感谢内容
            _buildThanks(),

            _buildLine(),

            // 联系我
            _buildTitle(title: S.of(context).connectMe),
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => push(context,
                    page: CustomWebViewPage(
                        title: S.of(context).zhihuPage,
                        url:
                            "https://www.zhihu.com/people/huo-lei-hong/activities",
                        favData: null)),
                child: Text(
                  S.of(context).zhihuName,
                  style: TextStyle(fontSize: 12, color: AppColor.text2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// app名称和版本
  Widget _buildAppName() {
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(
              S.of(context).appName,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "v1.4.0",
            style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// 感谢内容
  Widget _buildThanks() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Linkify(
        text: S.of(context).thankItems,
        onOpen: (link) => push(context,
            page: CustomWebViewPage(
                title: S.of(context).appName, url: link.url, favData: null)),
        style: TextStyle(fontSize: 12, color: AppColor.text2, height: 1.2),
        linkStyle: TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  /// 标题
  Widget _buildTitle({@required String title}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: AppColor.text2),
      ),
    );
  }

  /// 概述的Item
  Widget _buildOverviewItem(
      {@required IconData icon,
      @required String text,
      @required VoidCallback onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          height: 48,
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 24,
                color: AppColor.text3,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14, color: AppColor.text2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 1,
      color: AppColor.line2,
    );
  }
}
