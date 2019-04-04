import 'package:flutter_weather/commom_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget centerTitle;
  final IconButton leftBtn;
  final List<Widget> rightBtns;
  final Color color;
  final bool showShadowLine;

  CustomAppBar(
      {Key key,
      @required this.title,
      this.centerTitle,
      @required this.color,
      this.leftBtn,
      this.rightBtns = const [],
      this.showShadowLine = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rightPadding = -36.0;

    return AnimatedContainer(
      color: color,
      duration: const Duration(seconds: 2),
      height: preferredSize.height + getStatusHeight(context),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: getStatusHeight(context), left: 4, right: 4),
                height: preferredSize.height +
                    getStatusHeight(context) -
                    (showShadowLine ? 1 : 0),
                child: Row(
                  children: <Widget>[
                    // 左边的按钮
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Material(
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: leftBtn,
                      ),
                    ),

                    // 标题
                    Expanded(child: title),

                    // 右边的按钮(可能会有多个按钮)
                    rightBtns.isNotEmpty
                        ? Stack(
                            alignment: Alignment.centerRight,
                            children: rightBtns
                                .map((btn) => Padding(
                                      padding: EdgeInsets.only(
                                          right: rightPadding += 36),
                                      child: Material(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.transparent,
                                          child: btn),
                                    ))
                                .toList(),
                          )
                        : Container(),
                  ],
                ),
              ),

              // 中间的标题控件
              centerTitle != null
                  ? Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: centerTitle,
                    )
                  : Container()
            ],
          ),
          // 下面的阴影线
          Container(
            color: AppColor.colorLine2,
            height: showShadowLine ? 1 : 0,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(getAppBarHeight());
}
