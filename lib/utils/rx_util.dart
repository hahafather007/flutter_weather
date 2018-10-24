import 'dart:async';

/// 用来管理rxdart
class RxHolder {
  final streams = Set<StreamSubscription>();

  void add(StreamSubscription stream) {
    stream.onDone(() => streams.remove(stream));

    streams.add(stream);
  }

  void remove(StreamSubscription stream) {
    streams.firstWhere((v) => v == stream).cancel();

    streams.remove(stream);
  }

  void clear() {
    streams.forEach((v) => v.cancel());

    streams.clear();
  }
}
