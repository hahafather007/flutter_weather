import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mixing.dart';

/// 事件分发工具
class EventSendHolder {
  static final EventSendHolder _controller = EventSendHolder._internal();

  factory EventSendHolder() => _controller;

  final _eventBroadcast = StreamController<Pair<String, dynamic>>();
  Stream<Pair<String, dynamic>> event;

  EventSendHolder._internal() {
    event = _eventBroadcast.stream.asBroadcastStream();
  }

  /// [tag]表示标识符
  /// [event]表示要发送的事件
  void sendEvent({@required String tag, @required dynamic event}) =>
      _eventBroadcast.add(Pair(tag, event));

  void dispose() {
    _eventBroadcast.close();
  }
}
