import 'package:flutter_weather/commom_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final IconButton leftBtn;
  final List<IconButton> rightBtns;
  final Color color;
  final bool showShadow;

  CustomAppBar(
      {Key key,
      @required this.title,
      @required this.color,
      this.leftBtn,
      this.rightBtns = const [],
      this.showShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rightPadding = -36.0;

    return Container(
      color: color,
      height: preferredSize.height + getSysStatsHeight(context),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: getSysStatsHeight(context)),
            height: preferredSize.height + getSysStatsHeight(context) - 1,
            child: Row(
              children: <Widget>[
                // 左边的按钮
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 2.5),
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
                    padding: const EdgeInsets.only(right: 2.5),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: rightBtns
                          .map((btn) => Padding(
                                padding:
                                    EdgeInsets.only(right: rightPadding += 36),
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
            color: showShadow ? AppColor.colorShadow : color,
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
