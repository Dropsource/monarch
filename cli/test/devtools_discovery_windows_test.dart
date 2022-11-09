@TestOn('windows')

import 'package:monarch_cli/src/task_runner/devtools_discovery.dart.dart';
import 'package:test/test.dart';

void main() {
  group('DevtoolsDiscovery', () {
    test('finds devtools uri in line', () async {
      var stream = Stream.fromIterable([
        '💪 Running with sound null safety 💪\r\n',
        '\r\n',
        'An Observatory debugger and profiler on Windows is available at: http://127.0.0.1:64848/Zv49UbpDT1I=/\r\n',
        'Task is ready after 11.0sec',
        'The Flutter DevTools debugger and profiler on Windows is available at: http://127.0.0.1:9101?uri=http://127.0.0.1:64848/Zv49UbpDT1I=/\r\n'
      ]);
      var discovery = DevtoolsDiscovery();
      expect(discovery.status, DiscoveryStatus.initial);
      discovery.listen(stream);
      expect(discovery.status, DiscoveryStatus.listening);
      await Future.delayed(Duration());
      expect(discovery.status, DiscoveryStatus.found);
      expect(discovery.devtoolsUri, isNotNull);
      expect(
          discovery.devtoolsUri,
          Uri.parse(
              'http://127.0.0.1:9101?uri=http://127.0.0.1:64848/Zv49UbpDT1I=/'));

      await discovery.cancel();
      expect(discovery.status, DiscoveryStatus.found);
    });

    test('finds devtools uri in multi line string', () async {
      var stream = Stream.fromIterable([
        '''
Task is ready after 11.0sec
The Flutter DevTools debugger and profiler on Windows is available at: http://127.0.0.1:9101?uri=http://127.0.0.1:64848/Zv49UbpDT1I=/
'''
      ]);
      var discovery = DevtoolsDiscovery();
      discovery.listen(stream);
      await Future.delayed(Duration());
      expect(discovery.devtoolsUri, isNotNull);
      expect(
          discovery.devtoolsUri,
          Uri.parse(
              'http://127.0.0.1:9101?uri=http://127.0.0.1:64848/Zv49UbpDT1I=/'));
    });

    test('finds devtools uri when it is encoded', () async {
      var stream = Stream.fromIterable([
        'The Flutter DevTools debugger and profiler on Windows is available at: http://127.0.0.1:61188?uri=http%3A%2F%2F127.0.0.1%3A61146%2FdC1cULtWZEQ%3D%2F\n'
      ]);
      var discovery = DevtoolsDiscovery();
      expect(discovery.status, DiscoveryStatus.initial);
      discovery.listen(stream);
      expect(discovery.status, DiscoveryStatus.listening);
      await Future.delayed(Duration());
      expect(discovery.status, DiscoveryStatus.found);
      expect(discovery.devtoolsUri, isNotNull);
      expect(
          discovery.devtoolsUri,
          Uri.parse(
              'http://127.0.0.1:61188?uri=http%3A%2F%2F127.0.0.1%3A61146%2FdC1cULtWZEQ%3D%2F'));

      await discovery.cancel();
      expect(discovery.status, DiscoveryStatus.found);
    });

    test('does not find devtools uri', () async {
      var stream = Stream.fromIterable([
        '💪 Running with sound null safety 💪\r\n',
        '\r\n',
        'An Observatory debugger and profiler on Windows is available at: http://127.0.0.1:64848/Zv49UbpDT1I=/\r\n',
        'Task is ready after 11.0sec'
      ]);
      var discovery = DevtoolsDiscovery();
      expect(discovery.status, DiscoveryStatus.initial);
      discovery.listen(stream);
      expect(discovery.status, DiscoveryStatus.listening);
      await Future.delayed(Duration());
      expect(discovery.devtoolsUri, isNull);
      await discovery.cancel();
      expect(discovery.status, DiscoveryStatus.notFound);
    });
  });
}
