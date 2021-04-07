import 'subscription.dart';

class PubSub {
  final _subscriptions = Map<String?, Set<Subscription?>?>();

  void publish(String? topic, dynamic message) {
    if (_subscriptions.containsKey(topic)) {
      for (var sub in _subscriptions[topic]!) {
        sub?.controller?.add(message);
      }
    }
  }

  void publishMany(List<String?> topics, dynamic message) {
    for (var topic in topics) {
      if (_subscriptions.containsKey(topic)) {
        for (var sub in _subscriptions[topic]!) {
          sub?.controller?.add(message);
        }
      }
    }
  }

  void publishAll(dynamic message) {
    for (var topic in _subscriptions.keys) {
      for (var sub in _subscriptions[topic]!) {
        sub?.controller?.add(message);
      }
    }
  }

  Subscription? subscribe(String? topic) {
    Subscription? sub = Subscription(topic);
    _subscriptions.putIfAbsent(topic, () => Set<Subscription?>())?.add(sub);
    return sub;
  }

  Future<void>? unsubscribe(Subscription? subscriber) async {
    if (_subscriptions.containsKey(subscriber?.topic)) {
      _subscriptions[subscriber?.topic]!.remove(subscriber);

      if (_subscriptions[subscriber?.topic]!.isEmpty) {
        _subscriptions.remove(subscriber?.topic);
      }
    }

    await subscriber?.close();
  }

  Future<void>? unsubscribeMany(List<Subscription?>? subscribers) async {
    for (var sub in subscribers!) {
      await unsubscribe(sub);
    }
  }

  Future<void>? unsubscribeAll(String? topic) async {
    if (_subscriptions.containsKey(topic)) {
      Set<Subscription?>? subs = Set.from(_subscriptions[topic]!);
      for (var sub in subs) {
        await unsubscribe(sub);
      }
    }
  }
}