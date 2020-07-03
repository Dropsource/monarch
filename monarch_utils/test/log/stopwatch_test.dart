import 'package:test/test.dart';
import 'package:monarch_utils/log.dart';

void main() {
  group('Stopwatch', () {
    group('toString()', () {
      Stopwatch s;

      tearDown(() {
        manualNow = null;
      });

      void verify({Duration manualLapse, String expected}) {
        manualNow = DateTime(2019, 1, 1, 0, 0, 0, 0, 0);

        s = Stopwatch()..start();

        manualNow = manualNow.add(manualLapse);

        s.stop();

        expect(s.toString(), expected);
      }

      test('microseconds', () {
        verify(manualLapse: Duration(microseconds: 0), expected: '0µs');
        verify(manualLapse: Duration(microseconds: 1), expected: '1µs');
        verify(manualLapse: Duration(microseconds: 2), expected: '2µs');
        verify(manualLapse: Duration(microseconds: 3), expected: '3µs');
        verify(manualLapse: Duration(microseconds: 99), expected: '99µs');
        verify(manualLapse: Duration(microseconds: 100), expected: '100µs');
        verify(manualLapse: Duration(microseconds: 101), expected: '101µs');
        verify(manualLapse: Duration(microseconds: 998), expected: '998µs');
        verify(manualLapse: Duration(microseconds: 999), expected: '999µs');
        verify(manualLapse: Duration(microseconds: 1000), expected: '1ms');
      });

      test('milliseconds', () {
        verify(manualLapse: Duration(microseconds: 1000), expected: '1ms');
        verify(manualLapse: Duration(microseconds: 1001), expected: '1ms');
        verify(manualLapse: Duration(microseconds: 1002), expected: '1ms');
        verify(manualLapse: Duration(milliseconds: 1), expected: '1ms');
        verify(manualLapse: Duration(milliseconds: 99), expected: '99ms');
        verify(manualLapse: Duration(milliseconds: 100), expected: '100ms');
        verify(manualLapse: Duration(milliseconds: 101), expected: '101ms');
        verify(manualLapse: Duration(milliseconds: 998), expected: '998ms');
        verify(manualLapse: Duration(milliseconds: 999), expected: '999ms');
        verify(manualLapse: Duration(milliseconds: 1000), expected: '1.0sec');
      });

      test('seconds', () {
        verify(manualLapse: Duration(milliseconds: 1000), expected: '1.0sec');
        verify(manualLapse: Duration(milliseconds: 1001), expected: '1.0sec');
        verify(manualLapse: Duration(milliseconds: 1500), expected: '1.5sec');
        verify(manualLapse: Duration(milliseconds: 1900), expected: '1.9sec');
        verify(manualLapse: Duration(milliseconds: 1999), expected: '2.0sec');
        verify(manualLapse: Duration(seconds: 1), expected: '1.0sec');
        verify(manualLapse: Duration(seconds: 2), expected: '2.0sec');
        verify(manualLapse: Duration(seconds: 3), expected: '3.0sec');
        verify(
            manualLapse: Duration(seconds: 1, milliseconds: 1),
            expected: '1.0sec');
        verify(
            manualLapse: Duration(seconds: 1, milliseconds: 100),
            expected: '1.1sec');
        verify(
            manualLapse: Duration(seconds: 1, milliseconds: 299),
            expected: '1.3sec');
        verify(
            manualLapse: Duration(seconds: 9, milliseconds: 900),
            expected: '9.9sec');
        verify(
            manualLapse: Duration(seconds: 59, milliseconds: 450),
            expected: '59.5sec');
        verify(manualLapse: Duration(seconds: 60), expected: '1.0min');
      });

      test('minutes', () {
        verify(manualLapse: Duration(seconds: 60), expected: '1.0min');
        verify(manualLapse: Duration(seconds: 61), expected: '1.0min');
        verify(manualLapse: Duration(seconds: 62), expected: '1.0min');

        verify(
            manualLapse: Duration(minutes: 1, seconds: 3), expected: '1.1min');
        verify(
            manualLapse: Duration(minutes: 1, seconds: 9), expected: '1.1min');

        verify(
            manualLapse: Duration(minutes: 1, seconds: 10), expected: '1.2min');
        verify(
            manualLapse: Duration(minutes: 1, seconds: 14), expected: '1.2min');

        verify(
            manualLapse: Duration(minutes: 1, seconds: 15), expected: '1.3min');
        verify(
            manualLapse: Duration(minutes: 1, seconds: 20), expected: '1.3min');

        verify(
            manualLapse: Duration(minutes: 1, seconds: 21), expected: '1.4min');
        verify(
            manualLapse: Duration(minutes: 1, seconds: 27), expected: '1.4min');

        verify(
            manualLapse: Duration(minutes: 1, seconds: 28), expected: '1.5min');
        verify(
            manualLapse: Duration(minutes: 1, seconds: 32), expected: '1.5min');

        verify(
            manualLapse: Duration(minutes: 1, seconds: 51), expected: '1.9min');
        verify(
            manualLapse: Duration(minutes: 1, seconds: 57), expected: '1.9min');

        verify(
            manualLapse: Duration(minutes: 1, seconds: 58), expected: '2.0min');
        verify(
            manualLapse: Duration(minutes: 2, seconds: 3), expected: '2.0min');

        verify(
            manualLapse: Duration(minutes: 2, seconds: 4), expected: '2.1min');
        verify(
            manualLapse: Duration(minutes: 2, seconds: 9), expected: '2.1min');

        verify(
            manualLapse: Duration(minutes: 10500, seconds: 0),
            expected: '10500.0min');
      });

      test('not started', () {
        s = Stopwatch();

        expect(s.toString(), 'stopwatch-not-started');
      });

      test('not stopped', () {
        s = Stopwatch()..start();

        expect(s.toString(), 'stopwatch-not-stopped');
      });
    });

    group('duration', () {
      test('throws if not started', () {
        var s = Stopwatch();
        expect(() => s.duration, throwsStateError);
      });

      test('throws if not stopped', () {
        var s = Stopwatch();
        s.start();
        expect(() => s.duration, throwsStateError);
      });

      test('returns duration', () async {
        var s = Stopwatch();
        s.start();
        await Future.delayed(Duration(milliseconds: 10));
        s.stop();
        expect(s.duration, isNotNull);
        expect(s.duration.inMilliseconds >= 10, isTrue);
      });
    });
  });
}
