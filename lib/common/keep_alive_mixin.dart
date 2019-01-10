import 'package:flutter_weather/commom_import.dart';

/// 修改自[AutomaticKeepAliveClientMixin]
@optionalTypeArgs
mixin MustKeepAliveMixin<T extends StatefulWidget> on State<T> {
  KeepAliveHandle _keepAliveHandle;

  void _ensureKeepAlive() {
    assert(_keepAliveHandle == null);
    _keepAliveHandle = KeepAliveHandle();
    KeepAliveNotification(_keepAliveHandle).dispatch(context);
  }

  void _releaseKeepAlive() {
    _keepAliveHandle.release();
    _keepAliveHandle = null;
  }

  /// Whether the current instance should be kept alive.
  ///
  /// Call [updateKeepAlive] whenever this getter's value changes.
  @protected
  bool get wantKeepAlive;

  /// Ensures that any [AutomaticKeepAlive] ancestors are in a good state, by
  /// firing a [KeepAliveNotification] or triggering the [KeepAliveHandle] as
  /// appropriate.
  @protected
  void updateKeepAlive() {
    if (wantKeepAlive) {
      if (_keepAliveHandle == null) _ensureKeepAlive();
    } else {
      if (_keepAliveHandle != null) _releaseKeepAlive();
    }
  }

  @override
  void initState() {
    super.initState();
    if (wantKeepAlive) _ensureKeepAlive();
  }

  /// 将原来的[deactivate]改成[dispose]实现一定会保活
  @override
  void dispose() {
    if (_keepAliveHandle != null) _releaseKeepAlive();
    super.dispose();
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    if (wantKeepAlive && _keepAliveHandle == null) _ensureKeepAlive();
    return null;
  }
}
