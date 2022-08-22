import 'package:monarch_cli/src/config/monarch_package_compatibility.dart';
import 'package:test/test.dart';
import 'package:pub_semver/pub_semver.dart' as pub;

void main() {
  void isCompatible({required String flutter, required String monarch}) {
    var compatibility = MonarchPackageCompatibility(flutter);
    expect(compatibility.isMonarchPackageCompatible(pub.Version.parse(monarch)),
        isTrue);
  }

  void isIncompatible({required String flutter, required String monarch}) {
    var compatibility = MonarchPackageCompatibility(flutter);
    expect(compatibility.isMonarchPackageCompatible(pub.Version.parse(monarch)),
        isFalse);
  }

  group('MonarchPackageCompatibility', () {
    group('any supported flutter version', () {
      test('is compatible', () {
        isCompatible(flutter: '3.0.5', monarch: '2.4.0-pre.2');
        isCompatible(flutter: '3.0.2', monarch: '2.4.0-pre.3');
        isCompatible(flutter: '3.0.1', monarch: '2.4.0');
        isCompatible(flutter: '2.5.0', monarch: '2.4.0-pre.2');
        isCompatible(flutter: '3.0.5', monarch: '2.4.1');
      });

      test('is incompatible', () {
        isIncompatible(flutter: '3.0.1', monarch: '2.4.0-pre.1');
        isIncompatible(flutter: '3.0.1', monarch: '2.3.0-pre.2');
        isIncompatible(flutter: '3.0.5', monarch: '2.3.9');
        isIncompatible(flutter: '2.5.1', monarch: '1.0.2');
      });

      test('incompatibilityMessage', () {
        expect(
            MonarchPackageCompatibility('3.0.5').incompatibilityMessage,
            'Use monarch package version ^2.4.0-pre.2 or greater.');
      });
    });
  });
}
