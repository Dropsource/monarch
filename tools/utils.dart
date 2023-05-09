import 'dart:io';

import 'package:path/path.dart' as p;

void createDirectoryIfNeeded(String path) {
  var dir = Directory(path);
  if (!dir.existsSync()) dir.createSync(recursive: true);
}

String readPubspecVersion(String path) {
  var contents = File(path).readAsStringSync();
  var r = RegExp(r'^version: (\S+)$', multiLine: true);
  try {
    var version = r.firstMatch(contents)!.group(1)!;
    return version;
  } catch (e) {
    print('Error parsing version from pupspec.yaml');
    print(e);
    return 'unknown';
  }
}

void exitIfNeeded(ProcessResult result, String errorMessage,
    {List<int>? successExitCodes}) {
  var success = successExitCodes ?? [0];
  if (!success.contains(result.exitCode)) {
    print(errorMessage);
    print(result.stdout);
    print(result.stderr);
    exit(1);
  }
}

void exitIfNeededCMake(ProcessResult result, String errorMessage) {
  if (result.stderr.toString().isNotEmpty ||
      result.stdout.toString().contains('Build FAILED')) {
    print('');
    print(errorMessage);
    print('CMake output:');
    print('');
    print(result.stdout);
    print(result.stderr);
    exit(1);
  }
}

void writeInternalFile(String internal, String name, String contents) {
  createDirectoryIfNeeded(internal);
  var file = File(p.join(internal, name));
  file.writeAsStringSync(contents, mode: FileMode.writeOnly);
}
