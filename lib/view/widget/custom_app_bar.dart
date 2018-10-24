import 'package:flutter_weather/commom_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconButton leftBtn;
  final List<IconButton> rightBtns;
  final Color color;

  CustomAppBar(
      {Key key,
      @required this.title,
      @required this.color,
      this.leftBtn,
      this.rightBtns = const []})
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
            alignment: Alignment.bottomCenter,
            height: preferredSize.height + getSysStatsHeight(context) - 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                /// 左边的按钮
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 7.5, bottom: 3),
                    alignment: Alignment.bottomLeft,
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: leftBtn,
                    ),
                  ),
                ),

                /// 标题
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),

                /// 右边的按钮(可能会有多个按钮)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 7.5, bottom: 3),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: rightBtns
                          .map((btn) => Padding(
                                padding: EdgeInsets.only(
                                    right: rightPadding += 36.0),
                                child: Material(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.circular(50.0),
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
          Container(
            color: AppColor.colorShadow,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
