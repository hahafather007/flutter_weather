import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/gank_data.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/read_content_page.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/viewmodel/ganhuo_viewmodel.dart';

class GanHuoPage extends StatefulWidget {
  @override
  State createState() => GanHuoState();
}

class GanHuoState extends PageState<GanHuoPage> {
  final _viewModel = GanHuoViewModel();

  @override
  void initState() {
    super.initState();

    _viewModel
      ..loadTitle()
      ..error
          .stream
          .where((b) => b)
          .listen((_) => networkError(
              errorText: S.of(context).readTitleFail, retry: _viewModel.reload))
          .bindLife(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafKey,
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.titles.stream,
          builder: (context, snapshot) {
            final List<GankTitle> titles = snapshot.data ?? [];

            return DefaultTabController(
              length: titles.length,
              child: Column(
                children: <Widget>[
                  CustomAppBar(
                    title: Text(
                      S.of(context).read,
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
                      labelPadding: const EdgeInsets.only(),
                      tabs: titles
                          .map((title) => Tab(text: title.title))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: AppColor.read,
                      child: TabBarView(
                        children: titles
                            .map((title) => ReadContentPage(
                                  key: Key("ReadContentPage${title.type}"),
                                  title: title,
                                  isGanHuo: true,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
