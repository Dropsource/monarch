// ignore_for_file: non_constant_identifier_names

import 'package:test/test.dart';
import 'package:pub_semver/pub_semver.dart' as pub;

void main() {
  group('pub.Version', () {
    test('comparison with pre release', () {
      var version_2_3_0_pre = pub.Version(2, 3, 0, pre: '1.0.pre');

      void isMoreThan(String version) {
        expect(version_2_3_0_pre > pub.Version.parse(version), isTrue);
      }

      void isEqualTo(String version) {
        expect(version_2_3_0_pre == pub.Version.parse(version), isTrue);
      }

      void isLessThan(String version) {
        expect(version_2_3_0_pre < pub.Version.parse(version), isTrue);
      }

      isMoreThan('2.3.0-0.1.pre');
      isMoreThan('2.2.0-10.3.pre');
      isMoreThan('2.2.0-10.1.pre');
      isMoreThan('2.0.6');

      isEqualTo('2.3.0-1.0.pre');

      isLessThan('2.3.0-2.0.pre');
      isLessThan('2.3.0');
      isLessThan('2.3.1-1.0.pre');
      isLessThan('2.3.1');
      isLessThan('2.3.2');
      isLessThan('2.4.2');
    });
  });
}
