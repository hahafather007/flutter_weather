import 'package:flutter/material.dart';

/// 修改自[AutomaticKeepAliveClientMixin]
@optionalTypeArgs
mixin MustKeepAliveMixin<T extends StatefulWidget> on State<T> {
  KeepAliveHandle _keepAliveHandle;

  void _ensureKeepAlive() {
    if (_keepAliveHandle == null) {
      _keepAliveHandle = KeepAliveHandle();
      KeepAliveNotification(_keepAliveHandle).dispatch(context);
    }
  }

  void _releaseKeepAlive() {
    _keepAliveHandle?.release();
    _keepAliveHandle = null;
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();

    _ensureKeepAlive();
  }

  /// 将原来的[deactivate]改成[dispose]实现一定会保活
  @override
  @mustCallSuper
  void dispose() {
    if (_keepAliveHandle != null) _releaseKeepAlive();
    super.dispose();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    _ensureKeepAlive();

    return null;
  }
}
