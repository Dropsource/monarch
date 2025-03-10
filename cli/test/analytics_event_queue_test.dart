import 'package:test/test.dart';
import 'package:monarch_cli/src/analytics/analytics_event_queue.dart';
import 'package:monarch_cli/src/analytics/analytics_api.dart';
import 'package:monarch_cli/src/analytics/analytics_event.dart';

void main() {
  group('AnalyticsEventQueue', () {
    late AnalyticsEventsQueue queue;

    group('enqueues and records successfully', () {
      late TrueApi api;

      setUp(() {
        api = TrueApi();
        queue = AnalyticsEventsQueue(api);
      });

      test('enqueues and processes 1 event', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        expect(queue.isProcessing, isFalse);
        expect(queue.queue.isEmpty, isTrue);
        expect(api.eventsProcessed, 1);
      });

      test('enqueues and processes 2 events', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        queue.enqueue(AnalyticsEvent('foo', {'bar': 2}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        expect(queue.isProcessing, isFalse);
        expect(queue.queue.isEmpty, isTrue);
        expect(api.eventsProcessed, 2);
      });

      test('enqueues and processes multiple events', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;

        queue.enqueue(AnalyticsEvent('foo', {'bar': 2}));
        queue.enqueue(AnalyticsEvent('foo', {'bar': 3}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;

        queue.enqueue(AnalyticsEvent('foo', {'bar': 4}));
        await Future.microtask(
            () => queue.enqueue(AnalyticsEvent('foo', {'bar': 5})));
        await Future(() => queue.enqueue(AnalyticsEvent('foo', {'bar': 6})));

        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        expect(queue.isProcessing, isFalse);
        expect(api.eventsProcessed, 6);
      });
    });

    group('enqueues and records unsuccessfully', () {
      late FalseApi api;

      setUp(() {
        api = FalseApi();
        queue = TestAnalyticsEventsQueue(api);
      });

      test('enqueues 1 event, retries', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        expect(queue.isProcessing, isFalse);
        expect(queue.queue.isEmpty, isTrue);
        expect(queue.retryQueue.isEmpty, isFalse);
        expect(queue.retryQueue.length, 1);
        expect(api.eventsAttempts, 1);
        await Future.delayed(testRetryDuration);
        expect(api.eventsAttempts, 2);
      });

      test('enqueues 2 events, retries both', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        queue.enqueue(AnalyticsEvent('foo', {'bar': 2}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        expect(queue.isProcessing, isFalse);
        expect(queue.queue.isEmpty, isTrue);
        expect(queue.retryQueue.isEmpty, isFalse);
        expect(queue.retryQueue.length, 2);
        expect(api.eventsAttempts, 2);
        await Future.delayed(testRetryDuration);
        expect(api.eventsAttempts, 4);
      });

      test('enqueues 1 event then another, retries both', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;

        queue.enqueue(AnalyticsEvent('foo', {'bar': 2}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;

        await Future.delayed(testRetryDuration);

        expect(queue.queue.isEmpty, isTrue);
        expect(queue.retryQueue.isEmpty, isFalse);
        expect(queue.retryQueue.length, 2);
        expect(api.eventsAttempts, 4);
      });

      test('enqueues multiple events', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;

        queue.enqueue(AnalyticsEvent('foo', {'bar': 2}));
        queue.enqueue(AnalyticsEvent('foo', {'bar': 3}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;

        queue.enqueue(AnalyticsEvent('foo', {'bar': 4}));
        await Future.microtask(
            () => queue.enqueue(AnalyticsEvent('foo', {'bar': 5})));
        await Future(() => queue.enqueue(AnalyticsEvent('foo', {'bar': 6})));

        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;

        expect(queue.queue.isEmpty, isTrue);
        expect(queue.retryQueue.isEmpty, isFalse);
        expect(queue.retryQueue.length, 6);
      });
    });

    group('when api fails and then suceeds', () {
      FalseThenTrueApi api;
      setUp(() {
        api = FalseThenTrueApi();
        queue = TestAnalyticsEventsQueue(api);
      });

      test('initial enqueue fails, retry succeeds', () async {
        queue.enqueue(AnalyticsEvent('foo', {'bar': 1}));
        queue.enqueue(AnalyticsEvent('foo', {'bar': 2}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        expect(queue.queue.isEmpty, isTrue);
        expect(queue.retryQueue.isEmpty, isFalse);
        expect(queue.retryQueue.length, 2);

        await queue.whileRetrying;

        expect(queue.isRetrying, isFalse);
        expect(queue.retryQueue.isEmpty, isTrue);
      });
    });

    group('500 or more events in retry queue', () {
      late FalseThenAlwaysTrueApi api;
      setUp(() {
        api = FalseThenAlwaysTrueApi();
        queue = TestAnalyticsEventsQueue(api);
      });
      void addEvents(int count) {
        for (var i = 0; i < count; i++) {
          queue.retryQueue.add(AnalyticsEvent('foo', {'bar': i}));
        }
      }

      test('499 events in retry queue, then add one, 500 events are processed',
          () async {
        addEvents(499);
        queue.enqueue(AnalyticsEvent('foo', {'bar': 12345}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        await queue.whileRetrying;

        expect(api.eventsSuccessfullyProcessed, 500);
      });

      test('500 events in retry queue, then add one, only 500 are processed',
          () async {
        addEvents(500);
        queue.enqueue(AnalyticsEvent('foo', {'bar': 12345}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        await queue.whileRetrying;

        expect(api.eventsSuccessfullyProcessed, 500);
      });

      test('501 events in retry queue, then add one, only 501 are processed',
          () async {
        addEvents(501);
        queue.enqueue(AnalyticsEvent('foo', {'bar': 12345}));
        expect(queue.isProcessing, isTrue);
        await queue.whileProcessing;
        await queue.whileRetrying;

        expect(api.eventsSuccessfullyProcessed, 501);
      });
    });
  });
}

const testRetryDuration = Duration(milliseconds: 100);

class TestAnalyticsEventsQueue extends AnalyticsEventsQueue {
  TestAnalyticsEventsQueue(super.api);
  @override
  Duration get timeBetweenRetries => testRetryDuration;
}

class TrueApi implements AbstractAnalyticsApi {
  int eventsProcessed = 0;
  @override
  Future<bool> recordMultipleEvents(List<AnalyticsEvent> list) {
    eventsProcessed += list.length;
    return Future.value(true);
  }

  @override
  Future<bool> recordSingleEvent(String collectionName, Object data) {
    return Future.value(true);
  }
}

class FalseApi implements AbstractAnalyticsApi {
  int eventsAttempts = 0;
  @override
  Future<bool> recordMultipleEvents(List<AnalyticsEvent> list) {
    eventsAttempts += list.length;
    return Future.value(false);
  }

  @override
  Future<bool> recordSingleEvent(String collectionName, Object data) {
    return Future.value(false);
  }
}

class FalseThenTrueApi implements AbstractAnalyticsApi {
  bool toggle = true;
  @override
  Future<bool> recordMultipleEvents(List<AnalyticsEvent> list) {
    toggle = !toggle;
    return Future.value(toggle);
  }

  @override
  Future<bool> recordSingleEvent(String collectionName, Object data) {
    return Future.value(true);
  }
}

class FalseThenAlwaysTrueApi implements AbstractAnalyticsApi {
  bool firstTime = true;
  int eventsSuccessfullyProcessed = 0;
  @override
  Future<bool> recordMultipleEvents(List<AnalyticsEvent> list) {
    if (firstTime) {
      firstTime = false;
      return Future.value(false);
    } else {
      eventsSuccessfullyProcessed += list.length;
      return Future.value(true);
    }
  }

  @override
  Future<bool> recordSingleEvent(String collectionName, Object data) {
    return Future.value(true);
  }
}
