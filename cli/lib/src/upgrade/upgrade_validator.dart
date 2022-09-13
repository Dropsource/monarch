import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:path/path.dart' as p;

import '../config/monarch_binaries.dart';
import '../config/validator.dart';

class UpgradeValidator extends Validator {
  final MonarchBinaries monarchBinaries;

  UpgradeValidator(this.monarchBinaries);

  @override
  String get foundErrorsMessage => 'Could not validate monarch directory';

  @override
  Future<void> validate() async {
    var errors = <String>[];

    /// validate:
    /// - monarch/bin/monarch (monarch.exe)
    /// - monarch/bin/cache
    /// - monarch/bin/internal

    errors.addAll(
        validateMonarchExecutablePath(monarchBinaries.monarchExecutablePath));

    errors.addAll(await _validateCacheDirectory());
    errors.addAll(await _validateInternalDirectory());

    validationErrors.addAll(errors);
  }

  static List<String> validateMonarchExecutablePath(
      String monarchExecutablePath) {
    var errors = <String>[];
    var parts = p.split(monarchExecutablePath);

    var expectedMonarchDir = 'monarch';
    var expectedBin = 'bin';
    var expectedMonarchExe =
        valueForPlatform(macos: 'monarch', windows: 'monarch.exe');
    var expectedPath =
        p.join(expectedMonarchDir, expectedBin, expectedMonarchExe);

    if (parts.length < 3) {
      errors.add(
          'Expected to find path $expectedPath, instead found $monarchExecutablePath');
      return errors;
    }

    var monarchDir = parts[parts.length - 3];
    var binDir = parts[parts.length - 2];
    var monarchExe = parts[parts.length - 1];
    var actualPath = p.join(monarchDir, binDir, monarchExe);

    if (monarchDir != expectedMonarchDir ||
        binDir != expectedBin ||
        monarchExe != expectedMonarchExe) {
      errors.add(
          'Expected to find path $expectedPath, instead found $actualPath');
    }

    return errors;
  }

  Future<List<String>> _validateCacheDirectory() async {
    var errors = <String>[];
    if (!await monarchBinaries.cacheDirectory.exists()) {
      var expected = p.join('monarch', 'bin', 'cache');
      errors.add('Expected to find directory $expected');
    }
    return errors;
  }

  Future<List<String>> _validateInternalDirectory() async {
    var errors = <String>[];
    if (!await monarchBinaries.internalDirectory.exists()) {
      var expected = p.join('monarch', 'bin', 'internal');
      errors.add('Expected to find directory $expected');
    }
    return errors;
  }
}
