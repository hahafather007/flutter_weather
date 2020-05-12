import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/read_content_page.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';
import 'package:flutter_weather/view/widget/loading_view.dart';
import 'package:flutter_weather/viewmodel/read_viewmodel.dart';

class ReadPage extends StatefulWidget {
  @override
  State createState() => ReadState();
}

class ReadState extends PageState<ReadPage> {
  final _viewModel = ReadViewModel();

  @override
  void initState() {
    super.initState();

    _viewModel
      ..loadTitle()
      ..error
          .stream
          .where((b) => b)
          .listen((_) => networkError(
              errorText: S.of(context).readTitleFail,
              retry: _viewModel.loadTitle))
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
            final List<ReadTitle> titles = snapshot.data ?? [];

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
                      isScrollable: true,
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
