import 'package:flutter_weather/commom_import.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() => SettingState();
}

class SettingState extends PageState<SettingPage> {
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
        color: AppColor.colorMain,
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
              Color selectColor = AppColor.colorMain;
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
                        pickerColor: AppColor.colorMain,
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
                          EventSendHolder().sendEvent(
                              tag: "themeChange", event: selectColor);
                          setState(() => AppColor.colorMain = selectColor);
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
            content: "0 B",
            onTap: () {},
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
        style: TextStyle(fontSize: 14, color: AppColor.colorMain),
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
    if (AppColor.colorMain == AppColor.lapisBlue) {
      return "青石色";
    } else if (AppColor.colorMain == AppColor.paleDogWood) {
      return "山茱萸";
    } else if (AppColor.colorMain == AppColor.greenery) {
      return "绿篱";
    } else if (AppColor.colorMain == AppColor.primroseYellow) {
      return "樱草黄";
    } else if (AppColor.colorMain == AppColor.flame) {
      return "烈焰红";
    } else if (AppColor.colorMain == AppColor.islandParadise) {
      return "天堂岛";
    } else if (AppColor.colorMain == AppColor.kale) {
      return "甘蓝";
    } else if (AppColor.colorMain == AppColor.pinkYarrow) {
      return "粉蓍草";
    } else if (AppColor.colorMain == AppColor.niagara) {
      return "尼亚加拉";
    } else {
      return "Fuck you!";
    }
  }
}
