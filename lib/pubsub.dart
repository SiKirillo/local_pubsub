library local_pubsub;

import 'subscription.dart';

/// [PubSub] manages its subscriptions.
/// You can subscribe and unsubscribe to topics, send them messages.
/// Example:
/// ```dart
/// PubSub pubsub = PubSub();
/// Subscription? sub = pubsub?.subscribe('topic');
/// sub?.stream?.listen((message) {
///   print(message);
/// });
///
/// pubsub.publish('topic', 'hello');
/// // console log - hello
/// pubsub.unsubscribe(sub);
/// ```
class PubSub {
  /// Map of topics and their subscribers.
  final _subscriptions = Map<String?, Set<Subscription?>?>();
  /// Default name. If you want to use multiple pubsub you can set a name for each.
  String? name = 'Default';

  PubSub({this.name});

  /// Sends messages to all subscribers of this topic.
  void publish(String? topic, dynamic message) {
    if (_subscriptions.containsKey(topic)) {
      _subscriptions[topic]!.forEach((sub) {
        if (sub?.isCanceled == true) {
          throw Exception("This subscription canceled");
        }
        sub?.send(message);
      });
    }
  }

  /// Sends messages to all subscribers of several topics.
  void publishMany(Set<String?> topics, dynamic message) {
    topics.forEach((topic) {
      publish(topic, message);
    });
  }

  /// Sends messages to all subscribers of all topics.
  void publishAll(dynamic message) {
    _subscriptions.keys.forEach((topic) {
      publish(topic, message);
    });
  }

  /// Creates and stores a subscription to a topic.
  /// Return [Subscription].
  Subscription? subscribe(String? topic) {
    Subscription? sub = Subscription({topic}, this.name);
    _subscriptions.putIfAbsent(topic, () => Set<Subscription?>())?.add(sub);
    return sub;
  }

  /// Creates and stores a subscription to several topics.
  /// Return [Subscription].
  Subscription? subscribeToMany(Set<String?>? topics) {
    Subscription? sub = Subscription(topics, this.name);
    topics!.forEach((topic) {
      _subscriptions.putIfAbsent(topic, () => Set<Subscription?>())?.add(sub);
    });
    return sub;
  }

  /// Deletes a subscription to a topic.
  Future<void>? unsubscribe(Subscription? subscription) async {
    if (subscription?.pubsub != this.name) {
      throw Exception("This subscription doesn\'t belong to this pubsub");
    }

    subscription?.topics!.forEach((topic) {
      if (_subscriptions.containsKey(topic)) {
        _subscriptions[topic]!.remove(subscription);

        if (_subscriptions[topic]!.isEmpty) {
          _subscriptions.remove(topic);
        }
      }
    });

    await subscription?.cancel();
  }

  /// Deletes multiple subscriptions at a time.
  Future<void>? unsubscribeMany(List<Subscription?>? subscribers) {
    subscribers!.forEach((sub) async {
      await unsubscribe(sub);
    });
  }

  /// Deletes all subscriptions to the specified topic.
  Future<void>? unsubscribeAll(String? topic) async {
    if (_subscriptions.containsKey(topic)) {
      Set<Subscription?>? subs = Set.from(_subscriptions[topic]!);
      subs.forEach((sub) async {
        await unsubscribe(sub);
      });
    }
  }

  /// Return set of pubsub topics
  Set<String?>? getTopics() {
    return _subscriptions.keys.toSet();
  }
}