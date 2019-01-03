import 'package:flutter_weather/commom_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final IconButton leftBtn;
  final List<IconButton> rightBtns;
  final Color color;
  final bool showShadowLine;

  CustomAppBar(
      {Key key,
      @required this.title,
      @required this.color,
      this.leftBtn,
      this.rightBtns = const [],
      this.showShadowLine = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rightPadding = -34.0;

    return Container(
      color: color,
      height: preferredSize.height + getSysStatsHeight(context),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: getSysStatsHeight(context), left: 6, right: 6),
            height: preferredSize.height +
                getSysStatsHeight(context) -
                (showShadowLine ? 1 : 0),
            child: Row(
              children: <Widget>[
                // 左边的按钮
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: leftBtn,
                    ),
                  ),
                ),

                // 标题
                title,

                // 右边的按钮(可能会有多个按钮)
                Expanded(
                  child: Container(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: rightBtns
                          .map((btn) => Padding(
                                padding:
                                    EdgeInsets.only(right: rightPadding += 34),
                                child: Material(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.transparent,
                                    child: btn),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 下面的阴影线
          Container(
            color: AppColor.colorLine,
            height: showShadowLine ? 1 : 0,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
