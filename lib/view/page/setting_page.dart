import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:flutter_weather/common/colors.dart';
import 'package:flutter_weather/generated/i18n.dart';
import 'package:flutter_weather/model/holder/event_send_holder.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_weather/utils/system_util.dart';
import 'package:flutter_weather/view/page/page_state.dart';
import 'package:flutter_weather/view/page/setting_module_page.dart';
import 'package:flutter_weather/view/widget/custom_app_bar.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() => SettingState();
}

class SettingState extends PageState<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          S.of(context).setting,
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
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: const ClampingScrollPhysics()),
        children: <Widget>[
          // 天气
          _buildTitle(title: S.of(context).weather),
          _buildItem(
            title: S.of(context).shareType,
            content: S.of(context).likeHammer,
            onTap: null,
          ),

          // 通用
          _buildTitle(title: S.of(context).commonUse),
          _buildItem(
            title: S.of(context).themeColor,
            content: getThemeName(),
            onTap: () {
              Color selectColor = Theme.of(context).accentColor;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(S.of(context).chooseTheme),
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
                        child: Text(S.of(context).cancel),
                      ),
                      FlatButton(
                        onPressed: () {
                          pop(context);
                          SharedDepository().setThemeColor(selectColor).then(
                              (_) => EventSendHolder().sendEvent(
                                  tag: "themeChange", event: selectColor));
                        },
                        child: Text(S.of(context).certain),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Container(height: 1, color: AppColor.line2),
          _buildItem(
            title: S.of(context).moduleControl,
            content: S.of(context).openOrCloseModule,
            onTap: () => push(context, page: SettingModulePage()),
          ),
        ],
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
      @required VoidCallback onTap}) {
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
                style: TextStyle(fontSize: 16, color: AppColor.text1),
              ),
              Text(
                content,
                style: TextStyle(fontSize: 14, color: AppColor.text2),
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
      return S.of(context).colorLapisBlue;
    } else if (color == AppColor.paleDogWood) {
      return S.of(context).colorPaleDogWood;
    } else if (color == AppColor.greenery) {
      return S.of(context).colorGreenery;
    } else if (color == AppColor.primroseYellow) {
      return S.of(context).colorPrimroseYellow;
    } else if (color == AppColor.flame) {
      return S.of(context).colorFlame;
    } else if (color == AppColor.islandParadise) {
      return S.of(context).colorIslandParadise;
    } else if (color == AppColor.kale) {
      return S.of(context).colorKale;
    } else if (color == AppColor.pinkYarrow) {
      return S.of(context).colorPinkYarrow;
    } else if (color == AppColor.niagara) {
      return S.of(context).colorNiagara;
    } else {
      return S.of(context).colorNone;
    }
  }
}
