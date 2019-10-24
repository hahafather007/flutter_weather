import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/language.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/view/page/read_content_page.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Column(
        children: <Widget>[
          CustomAppBar(
            title: Text(
              AppText.of(context).read,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            color: Theme.of(context).accentColor,
            leftBtn: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => EventSendHolder()
                  .sendEvent(tag: "homeDrawerOpen", event: true),
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: [
                Tab(text: AppText.of(context).xiandu),
                Tab(text: AppText.of(context).xianduApps),
                Tab(text: AppText.of(context).xianduImrich),
                Tab(text: AppText.of(context).xianduFunny),
                Tab(text: AppText.of(context).xianduAndroid),
                Tab(text: AppText.of(context).xianduDie),
                Tab(text: AppText.of(context).xianduThink),
                Tab(text: AppText.of(context).xianduIos),
                Tab(text: AppText.of(context).xianduBlog),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColor.colorRead,
              child: TabBarView(
                children: [
                  ReadContentPage(
                    key: Key("ReadContentPagewow"),
                    typeUrl: "wow",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPageapps"),
                    typeUrl: "apps",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPageimrich"),
                    typeUrl: "imrich",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPagefunny"),
                    typeUrl: "funny",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPageandroid"),
                    typeUrl: "android",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPagediediedie"),
                    typeUrl: "diediedie",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPagethinking"),
                    typeUrl: "thinking",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPageiOS"),
                    typeUrl: "iOS",
                  ),
                  ReadContentPage(
                    key: Key("ReadContentPageteamblog"),
                    typeUrl: "teamblog",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
