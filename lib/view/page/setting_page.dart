import 'package:flutter_weather/commom_import.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: const ClampingScrollPhysics()),
        children: <Widget>[
          // 天气
          _buildTitle(title: AppText.of(context).weather),
          _buildItem(
            title: "分享形式",
            content: "仿锤子便签",
            onTap: () {},
          ),

          // 通用
          _buildTitle(title: "通用"),
          _buildItem(
            title: "主题色",
            content: getThemeName(),
            onTap: () {
              Color selectColor = Theme.of(context).accentColor;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("选择主题色"),
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
                        child: Text("取消"),
                      ),
                      FlatButton(
                        onPressed: () {
                          pop(context);
                          SharedDepository().setThemeColor(selectColor).then(
                              (_) => EventSendHolder().sendEvent(
                                  tag: "themeChange", event: selectColor));
                        },
                        child: Text("确定"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Container(height: 1, color: AppColor.colorLine2),
          _buildItem(
            title: "模块管理",
            content: "启用/关闭模块",
            onTap: () {},
          ),
          Container(height: 1, color: AppColor.colorLine2),
          _buildItem(
            title: "清除缓存",
            content: ByteUtil.calculateSize(0),
            onTap: () => imageCache.clear(),
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
      return "青石色";
    } else if (color == AppColor.paleDogWood) {
      return "山茱萸";
    } else if (color == AppColor.greenery) {
      return "绿篱";
    } else if (color == AppColor.primroseYellow) {
      return "樱草黄";
    } else if (color == AppColor.flame) {
      return "烈焰红";
    } else if (color == AppColor.islandParadise) {
      return "天堂岛";
    } else if (color == AppColor.kale) {
      return "甘蓝";
    } else if (color == AppColor.pinkYarrow) {
      return "粉蓍草";
    } else if (color == AppColor.niagara) {
      return "尼亚加拉";
    } else {
      return "丢雷老母！";
    }
  }
}
