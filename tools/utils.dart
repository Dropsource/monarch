import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void addArgOptionFlutterSdk(ArgParser parser) {
  parser.addOption('flutter-sdk',
      abbr: 'f',
      help:
          'Path to the Flutter SDK to use. If blank, this command will run for '
          'each Flutter SDK declared in local_settings.yaml.');
}

void addArgOptionOut(ArgParser parser) {
  parser.addOption('out',
      abbr: 'o',
      help: 'Path to the monarch_ui/{flutter_id} output directory. Required if --flutter-sdk is set');
}

void addArgOptionHelp(ArgParser parser) {
  parser.addFlag('help', abbr: 'h');
}

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