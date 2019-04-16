import 'package:flutter_weather/commom_import.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() => SettingState();
}

class SettingState extends PageState<SettingPage> {
  final _viewModel = SettingViewModel();

  @override
  void initState() {
    super.initState();
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
          AppText.of(context).setting,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        color: Theme.of(context).accentColor,
        leftBtn: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => pop(context),
        ),
      ),
      body: LoadingView(
        loadingStream: _viewModel.isLoading.stream,
        child: StreamBuilder(
          stream: _viewModel.cacheSize.stream,
          builder: (context, snapshot) {
            final cacheSize = snapshot.data ?? AppText.of(context).caculating;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: const ClampingScrollPhysics()),
              children: <Widget>[
                // 天气
                _buildTitle(title: AppText.of(context).weather),
                _buildItem(
                  title: AppText.of(context).shareType,
                  content: AppText.of(context).likeHammer,
                  onTap: () {},
                ),

                // 通用
                _buildTitle(title: AppText.of(context).commonUse),
                _buildItem(
                  title: AppText.of(context).themeColor,
                  content: getThemeName(),
                  onTap: () {
                    Color selectColor = Theme.of(context).accentColor;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(AppText.of(context).chooseTheme),
                          content: Container(
                            height: 180,
                            child: BlockPicker(
                              availableColors: [
                                AppColor.lapisBlue,
                                AppColor.paleDogWood,
                                AppColor.greenery,
                                AppColor.primroseYellow,
                                AppColor.flame,
                                AppColor.islandParadise,
                                AppColor.kale,
                                AppColor.pinkYarrow,
                                AppColor.niagara,
                              ],
                              pickerColor: Theme.of(context).accentColor,
                              onColorChanged: (color) => selectColor = color,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => pop(context),
                              child: Text(AppText.of(context).cancel),
                            ),
                            FlatButton(
                              onPressed: () {
                                pop(context);
                                SharedDepository()
                                    .setThemeColor(selectColor)
                                    .then((_) => EventSendHolder().sendEvent(
                                        tag: "themeChange",
                                        event: selectColor));
                              },
                              child: Text(AppText.of(context).certain),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Container(height: 1, color: AppColor.colorLine2),
                _buildItem(
                  title: AppText.of(context).moduleControl,
                  content: AppText.of(context).openOrCloseModule,
                  onTap: () => push(context, page: SettingModulePage()),
                ),
                Container(height: 1, color: AppColor.colorLine2),
                _buildItem(
                  title: AppText.of(context).clearCache,
                  content: cacheSize,
                  onTap: () => _viewModel.clearCache(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 小标题
  Widget _buildTitle({@required String title}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor),
      ),
    );
  }

  /// 每个Item
  Widget _buildItem(
      {@required String title,
      @required String content,
      @required Function onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 66,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 16, color: AppColor.colorText1),
              ),
              Text(
                content,
                style: TextStyle(fontSize: 14, color: AppColor.colorText2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取主题名字
  String getThemeName() {
    final color = Theme.of(context).accentColor;

    if (color == AppColor.lapisBlue) {
      return AppText.of(context).colorLapisBlue;
    } else if (color == AppColor.paleDogWood) {
      return AppText.of(context).colorPaleDogWood;
    } else if (color == AppColor.greenery) {
      return AppText.of(context).colorGreenery;
    } else if (color == AppColor.primroseYellow) {
      return AppText.of(context).colorPrimroseYellow;
    } else if (color == AppColor.flame) {
      return AppText.of(context).colorFlame;
    } else if (color == AppColor.islandParadise) {
      return AppText.of(context).colorIslandParadise;
    } else if (color == AppColor.kale) {
      return AppText.of(context).colorKale;
    } else if (color == AppColor.pinkYarrow) {
      return AppText.of(context).colorPinkYarrow;
    } else if (color == AppColor.niagara) {
      return AppText.of(context).colorNiagara;
    } else {
      return AppText.of(context).colorNone;
    }
  }
}
