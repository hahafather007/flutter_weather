import 'package:flutter_weather/commom_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget centerTitle;
  final PreferredSizeWidget bottom;
  final IconButton leftBtn;
  final List<Widget> rightBtns;
  final Color color;
  final bool showShadow;

  CustomAppBar(
      {Key key,
      @required this.title,
      this.centerTitle,
      @required this.color,
      this.leftBtn,
      this.bottom,
      this.rightBtns = const [],
      this.showShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: showShadow ? 4.0 : 0.0,
      color: Colors.transparent,
      child: AnimatedContainer(
        height: preferredSize.height + getStatusHeight(context),
        duration: const Duration(seconds: 2),
        color: color,
        child: Stack(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: title,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              leading: leftBtn,
              actions: rightBtns,
              elevation: 0.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: bottom ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
}
