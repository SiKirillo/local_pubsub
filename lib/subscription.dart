library local_pubsub;

import 'dart:async';

/// Pubsub subscription result.
///
/// [Subscription] can receive messages from pubsub and process them on its [stream].
/// Example:
/// ```dart
/// PubSub pubsub = PubSub();
/// Subscription? sub = pubsub?.subscribe('topic');
/// sub?.stream?.listen((message) {
///   print(message);
/// });
/// ```
class Subscription {
  /// Topics that are subscribed to.
  final Set<String?>? _topics;
  /// Controller for listening to messages.
  final StreamController<String?>? _controller = StreamController();
  /// Pubsub name to check
  final String? _pubsub;
  /// Is subscription canceled
  bool? _isCanceled = false;

  Subscription(this._topics, this._pubsub);

  Set<String?>? get topics => _topics;
  Stream<dynamic>? get stream => _controller?.stream;
  String? get pubsub => _pubsub;
  bool? get isCanceled => _isCanceled;

  /// PubSub uses this method to send messages to subscription.
  /// This method not intended to be manual called.
  void send(dynamic message) {
    _controller?.add(message);
  }

  /// PubSub uses this method to cancel subscription on it
  /// This method not intended to be manual called.
  Future<void>? cancel() async {
    await _controller?.close();
    _isCanceled = true;
  }
}