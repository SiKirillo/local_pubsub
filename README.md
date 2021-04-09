# local_pubsub

A simple local pubsub library for Dart.

## What you can do

This library allows you to subscribe to different topics and send messages to all subscribers to this topic.

- Subscribe to topic

```dart
void main() {
    PubSub pubsub = PubSub();
    Subscription? sub = pubsub?.subscribe('topic');
}
```

- Unubscribe to topic

```dart
void main() {
    PubSub pubsub = PubSub();
    Subscription? sub = pubsub?.subscribe('topic');
    pubsub?.unsubscribe(sub);
}
```

- Publish message for topic

```dart
void main() {
    PubSub pubsub = PubSub();
    Subscription? sub = pubsub?.subscribe('topic');
    sub?.stream?.listen((message) {
        print(message);
    });
    
    pubsub?.publish('topic', 'hello');
}
```

