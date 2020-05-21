import 'dart:async';

import 'package:flutter/material.dart';

class ToastView extends StatefulWidget {
  final String msg;

  ToastView({@required this.msg});

  @override
  State createState() => _ToastState();
}

class _ToastState extends State<ToastView> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: const Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 2300),
        () => _controller.animateTo(0, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 36, right: 36),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: _animation.value != 0
                ? Material(
                    color: const Color(0xdd444444),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                      child: Text(
                        "${widget.msg}",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
          );
        },
      ),
    );
  }
}
