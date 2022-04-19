@TestOn('mac-os')

import 'package:monarch_cli/src/task_runner/observatory_discovery.dart';
import 'package:test/test.dart';

void main() {
  group('ObservatoryDiscovery', () {
    test('finds observatory url in Dart VM Service line', () async {
      var stream = Stream.fromIterable([
        'mac_app: FINE [MainWindowController] arguments ["/Users/bob/monarch/bin/cache/monarch_ui/flutter_macos_2.13.0-0.1.pre-beta/monarch_mac.app/Contents/MacOS/monarch", "--project-path", "/Users/bob/development/scratch/someone", "--log-level", "ALL"]',
        'mac_app: FINE [MainWindowController] Will use bundle at: /Users/bob/development/scratch/someone/.monarch',
        'flutter: The Dart VM service is listening on http://127.0.0.1:63982/DVBM41A0YTQ=/',
        'flutter: FINE [VmServiceClient] Connected to vm service socket ws://127.0.0.1:63982/DVBM41A0YTQ=/ws',
        'flutter: FINE [VmServiceClient] Got isolateId=isolates/1449702236947887'
      ]);
      var discovery = ObservatoryDiscovery();
      discovery.listen(stream);
      await Future.delayed(Duration());
      await discovery.cancel();
      expect(discovery.observatoryUri, isNotNull);
      expect(
          discovery.observatoryUri,
          Uri.parse(
              'http://127.0.0.1:63982/DVBM41A0YTQ=/'));
    });

    test('finds observatory url in Observatory string', () async {
      var stream = Stream.fromIterable([
        'mac_app: FINE [MainWindowController] arguments ["/Users/bob/monarch/bin/cache/monarch_ui/flutter_macos_2.13.0-0.1.pre-beta/monarch_mac.app/Contents/MacOS/monarch", "--project-path", "/Users/bob/development/scratch/someone", "--log-level", "ALL"]',
        'mac_app: FINE [MainWindowController] Will use bundle at: /Users/bob/development/scratch/someone/.monarch',
        'flutter: Observatory listening on http://127.0.0.1:64866/N62pN7E41Js=/',
        'flutter: FINE [VmServiceClient] Connected to vm service socket ws://127.0.0.1:63982/DVBM41A0YTQ=/ws',
        'flutter: FINE [VmServiceClient] Got isolateId=isolates/1449702236947887'
      ]);
      var discovery = ObservatoryDiscovery();
      discovery.listen(stream);
      await Future.delayed(Duration());
      await discovery.cancel();
      expect(discovery.observatoryUri, isNotNull);
      expect(
          discovery.observatoryUri,
          Uri.parse(
              'http://127.0.0.1:64866/N62pN7E41Js=/'));
    });

    test('cannot find observatory url in stream', () async {
      var stream = Stream.fromIterable([
        'mac_app: FINE [MainWindowController] arguments ["/Users/bob/monarch/bin/cache/monarch_ui/flutter_macos_2.13.0-0.1.pre-beta/monarch_mac.app/Contents/MacOS/monarch", "--project-path", "/Users/bob/development/scratch/someone", "--log-level", "ALL"]',
        'mac_app: FINE [MainWindowController] Will use bundle at: /Users/bob/development/scratch/someone/.monarch',
        'flutter: FOO listening on http://127.0.0.1:55334/N62pN7E41Js=/',
        'flutter: FINE [VmServiceClient] Connected to vm service socket ws://127.0.0.1:63982/DVBM41A0YTQ=/ws',
        'flutter: FINE [VmServiceClient] Got isolateId=isolates/1449702236947887'
      ]);
      var discovery = ObservatoryDiscovery();
      discovery.listen(stream);
      await Future.delayed(Duration());
      await discovery.cancel();
      expect(discovery.observatoryUri, isNull);
    });
  });
}
