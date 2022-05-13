import 'dart:io';
import 'utils.dart' as utils;
import 'paths.dart' as paths;

/// Writes monarch/bin/internal files:
/// - binaries_version.txt
/// - binaries_commit.txt
/// - min_flutter_version.txt
/// 
/// Other build_*.dart scripts write their own internal files.
void main() {
  
  utils.writeInternalFile('binaries_version.txt', 'local');

  var result = Process.runSync('git', ['rev-parse', 'HEAD'],
      workingDirectory: paths.root);
  if (result.exitCode != 0) {
    print('Error reading current git commit hash');
    print(result.stdout);
    print(result.stderr);
  }
  var hash = result.stdout.toString().trim();
  utils.writeInternalFile('binaries_revision.txt', utils.getVersionSuffix(hash));

  utils.writeInternalFile('min_flutter_version.txt', '2.4.0-4.0.pre');
}