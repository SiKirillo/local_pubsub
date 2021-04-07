import 'dart:async';

class Subscription {
  final String? _topic;
  final StreamController<String?>? _controller = StreamController();

  Subscription(this._topic);

  String? get topic => _topic;
  StreamController<dynamic>? get controller => _controller;
  Stream<dynamic>? get stream => _controller?.stream;

  Future<void>? close() async {
    await _controller?.close();
  }
}