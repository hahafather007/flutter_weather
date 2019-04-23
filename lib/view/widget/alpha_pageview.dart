import 'package:flutter_weather/commom_import.dart';

class AlphaPageView extends StatefulWidget {
  final int itemCount;
  final Axis scrollDirection;
  final bool reverse;
  final PageController controller;
  final ScrollPhysics physics;
  final bool pageSnapping;
  final ValueChanged<int> onPageChanged;
  final IndexedWidgetBuilder itemBuilder;

  AlphaPageView({
    Key key,
    this.itemCount,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    @required this.itemBuilder,
  }) : super(key: key);

  @override
  State createState() => _AlPhaPageState();
}

class _AlPhaPageState extends PageState<AlphaPageView> {
  PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? PageController();
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: widget.itemCount,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      onPageChanged: widget.onPageChanged,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      itemBuilder: widget.itemBuilder
    );
  }
}
