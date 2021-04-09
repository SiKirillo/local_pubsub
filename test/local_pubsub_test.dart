import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_pubsub/local_pubsub.dart';

void main() {
  test('subscribe to topic', () {
    final PubSub? localPubSub = PubSub();
    String? topic = 'topic';

    Subscription? sub = localPubSub?.subscribe(topic);
    expect(sub?.topics?.contains(topic), localPubSub?.getTopics()?.contains(topic));
  });

  test('publish topic', () async {
    final PubSub? localPubSub = PubSub();
    String? topic = 'topic';
    String? message = 'message';

    Subscription? sub = localPubSub?.subscribe(topic);
    String? deliveredMessage;

    sub?.stream?.listen((message) {
      deliveredMessage = message;
    });

    localPubSub?.publish(topic, message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessage, message);
  });

  test('publish multiple topics', () async {
    final PubSub? localPubSub = PubSub();
    String? topic1 = 'topic';
    String? topic2 = 'all';
    String? message = 'message';

    Subscription? sub1 = localPubSub?.subscribe(topic1);
    Subscription? sub2 = localPubSub?.subscribe(topic2);

    String? deliveredMessage1;
    String? deliveredMessage2;

    sub1?.stream?.listen((message) {
      deliveredMessage1 = message;
    });

    sub2?.stream?.listen((message) {
      deliveredMessage2 = message;
    });

    localPubSub?.publishMany({topic1, topic2}, message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessage1, message);
    expect(deliveredMessage2, message);
  });

  test('publish all topics', () async {
    final PubSub? localPubSub = PubSub();
    String? topic1 = 'topic';
    String? topic2 = 'all';
    String? topic3 = 'temp';
    String? message = 'message';

    Subscription? sub1 = localPubSub?.subscribe(topic1);
    Subscription? sub2 = localPubSub?.subscribe(topic2);
    Subscription? sub3 = localPubSub?.subscribe(topic3);

    String? deliveredMessage1;
    String? deliveredMessage2;
    String? deliveredMessage3;

    sub1?.stream?.listen((message) {
      deliveredMessage1 = message;
    });

    sub2?.stream?.listen((message) {
      deliveredMessage2 = message;
    });

    sub3?.stream?.listen((message) {
      deliveredMessage3 = message;
    });

    localPubSub?.publishAll(message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessage1, message);
    expect(deliveredMessage2, message);
    expect(deliveredMessage3, message);
  });

  test('publish several topics', () async {
    final PubSub? localPubSub = PubSub();
    String? topic1 = 'topic';
    String? topic2 = 'all';
    String? message = 'message';

    Subscription? sub = localPubSub?.subscribeToMany({topic1, topic2});
    List<String?>? deliveredMessages = [];

    sub?.stream?.listen((message) {
      deliveredMessages.add(message);
    });

    localPubSub?.publishMany({topic1, topic2}, message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessages.length, 2);
  });

  test('unsubscribe subscription', () async {
    final PubSub? localPubSub = PubSub();
    String? topic1 = 'topic';
    String? topic2 = 'all';
    String? message = 'message';

    Subscription? sub1 = localPubSub?.subscribe(topic1);
    Subscription? sub2 = localPubSub?.subscribe(topic2);

    String? deliveredMessage1;
    String? deliveredMessage2;

    sub1?.stream?.listen((message) {
      deliveredMessage1 = message;
    });

    sub2?.stream?.listen((message) {
      deliveredMessage2 = message;
    });

    await localPubSub?.unsubscribe(sub1);
    localPubSub?.publishMany({topic1, topic2}, message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessage1, null);
    expect(deliveredMessage2, message);
  });

  test('unsubscribe subscription and publish topic', () async {
    final PubSub? localPubSub = PubSub();
    String? topic = 'topic';
    String? message = 'message';

    Subscription? sub = localPubSub?.subscribe(topic);
    List<String?>? deliveredMessages = [];

    sub?.stream?.listen((message) {
      deliveredMessages.add(message);
    });

    localPubSub?.publish(topic, message);
    await localPubSub?.unsubscribe(sub);
    localPubSub?.publish(topic, message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessages.length, 1);
  });

  test('unsubscribe multiple topic', () async {
    final PubSub? localPubSub = PubSub();
    String? topic1 = 'topic';
    String? topic2 = 'all';
    String? message = 'message';

    Subscription? sub1 = localPubSub?.subscribe(topic1);
    Subscription? sub2 = localPubSub?.subscribe(topic1);
    Subscription? sub3 = localPubSub?.subscribe(topic2);

    String? deliveredMessage1;
    String? deliveredMessage2;
    String? deliveredMessage3;

    sub1?.stream?.listen((message) {
      deliveredMessage1 = message;
    });

    sub2?.stream?.listen((message) {
      deliveredMessage2 = message;
    });

    sub3?.stream?.listen((message) {
      deliveredMessage3 = message;
    });

    await localPubSub?.unsubscribeMany([sub1, sub2]);
    localPubSub?.publishMany({topic1, topic2}, message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessage1, null);
    expect(deliveredMessage2, null);
    expect(deliveredMessage3, message);
  });

  test('unsubscribe all topic', () async {
    final PubSub? localPubSub = PubSub();
    String? topic1 = 'topic';
    String? topic2 = 'all';
    String? message = 'message';

    Subscription? sub1 = localPubSub?.subscribe(topic1);
    Subscription? sub2 = localPubSub?.subscribe(topic1);
    Subscription? sub3 = localPubSub?.subscribe(topic2);

    String? deliveredMessage1;
    String? deliveredMessage2;
    String? deliveredMessage3;

    sub1?.stream?.listen((message) {
      deliveredMessage1 = message;
    });

    sub2?.stream?.listen((message) {
      deliveredMessage2 = message;
    });

    sub3?.stream?.listen((message) {
      deliveredMessage3 = message;
    });

    await localPubSub?.unsubscribeAll(topic1);
    localPubSub?.publishMany({topic1, topic2}, message);

    await Future.delayed(Duration(seconds: 1));
    expect(deliveredMessage1, null);
    expect(deliveredMessage2, null);
    expect(deliveredMessage3, message);
  });
}