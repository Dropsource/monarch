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
        isCompatible(flutter: '2.4.0-4.0.pre', monarch: '2.1.1');
        isCompatible(flutter: '2.4.1', monarch: '2.1.1');
        isCompatible(flutter: '2.5.0-1.0.pre', monarch: '2.2.1');
        isCompatible(flutter: '2.5.0', monarch: '2.2.2');
        isCompatible(flutter: '2.4.0-4.0.pre', monarch: '2.1.0');
      });

      test('is incompatible', () {
        isIncompatible(flutter: '2.5.0-1.0.pre', monarch: '2.0.0-pre.4');
        isIncompatible(flutter: '2.5.0-1.0.pre', monarch: '2.0.0-pre.2');
        isIncompatible(flutter: '2.4.0-4.0.pre', monarch: '1.1.0');
        isIncompatible(flutter: '2.4.0-4.0.pre', monarch: '2.0.0');
        isIncompatible(flutter: '2.4.1', monarch: '1.1.1');
        isIncompatible(flutter: '2.5.0-1.0.pre', monarch: '1.1.0-pre.3');
        isIncompatible(flutter: '2.5.0', monarch: '1.1.0-pre.4');
        isIncompatible(flutter: '2.5.1', monarch: '0.1.0');
        isIncompatible(flutter: '2.5.1', monarch: '1.0.2');
      });

      test('incompatibilityMessage', () {
        expect(
            MonarchPackageCompatibility('2.4.0-4.1.pre').incompatibilityMessage,
            'Use monarch package version ^2.1.0 or greater.');
      });
    });
  });
}
