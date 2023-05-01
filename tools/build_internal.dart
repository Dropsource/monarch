import 'dart:io';
import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;
import 'paths.dart';
import 'package:path/path.dart' as p;
import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

/// Writes monarch/bin/internal files:
/// - binaries_version.txt
/// - binaries_revision.txt
/// - min_flutter_version.txt
/// - etc.
void buildInternal(List<String> arguments) {
  var parser = ArgParser();

  parser.addOption('internal',
      help: 'Path to the internal directory. Default to out/bin/internal.');
  parser.addOption('binaries-version',
      help: 'The version of the Monarch binaries. Defaults to "local"');
  parser.addOption('revision',
      help:
          'The revision git hash. If blank, this script will use `git rev-parse` '
          'to find the HEAD revision.');
  parser.addOption('min-flutter-version',
      help: 'The minimum Flutter verison supported by this Monarch build. '
          'Defaults to "3.0.0"');

  utils.addArgOptionHelp(parser);

  var args = parser.parse(arguments);

  if (args['help']) {
    print(parser.usage);
    exit(0);
  }

  String internal_ = args['internal'] ?? local_out_paths.out_bin_internal;
  String binariesVersion = args['binaries-version'] ?? 'local';
  String minFlutterVersion = args['min-flutter-version'] ?? '3.0.0';

  utils.writeInternalFile(internal_, 'binaries_version.txt', binariesVersion);

  String? revision = args['revision'];

  if (revision == null) {
    var result = Process.runSync('git', ['rev-parse', 'HEAD'],
        workingDirectory: local_repo_paths.root);
    if (result.exitCode != 0) {
      print('Error reading current git commit hash');
      print(result.stdout);
      print(result.stderr);
    }
    var hash = result.stdout.toString().trim();
    revision = local_utils.getVersionSuffix(hash);
  }

  utils.writeInternalFile(internal_, 'binaries_revision.txt', revision);

  utils.writeInternalFile(
      internal_, 'min_flutter_version.txt', minFlutterVersion);

  {
    var version =
        utils.readPubspecVersion(p.join(local_repo_paths.cli, 'pubspec.yaml'));
    version = local_utils.getVersionSuffix(version);
    local_utils.writeInternalFile('cli_version.txt', version);
  }

  {
    var version = utils.readPubspecVersion(
        p.join(local_repo_paths.controller, 'pubspec.yaml'));
    version = local_utils.getVersionSuffix(version);

    utils.writeInternalFile(internal_, 'controller_version.txt', version);
  }

  {
    var version = utils.readPubspecVersion(
        p.join(local_repo_paths.preview_api, 'pubspec.yaml'));
    version = local_utils.getVersionSuffix(version);

    local_utils.writeInternalFile('preview_api_version.txt', version);
  }

  {
    var version = functionForPlatform(
        macos: readMacosProjectVersion,
        windows: readWindowsProjectVersion,
        linux: readLinuxProjectVersion);
    version = local_utils.getVersionSuffix(version);
    local_utils.writeInternalFile('platform_app_version.txt', version);
  }
}

String readMacosProjectVersion() {
  var result = Process.runSync('xcodebuild', ['-showBuildSettings'],
      workingDirectory: local_repo_paths.platform_macos);
  if (result.exitCode != 0) {
    print('Error running xcodebuild -showBuildSettings');
    print(result.stdout);
    print(result.stderr);
    return 'unknown';
  }
  var contents = result.stdout.toString();
  var r = RegExp(r'^\s*MARKETING_VERSION = (\S+)$', multiLine: true);
  try {
    var version = r.firstMatch(contents)!.group(1)!;
    return version;
  } catch (e) {
    print('Error parsing version from xcode build setings');
    print(e);
    return 'unknown';
  }
}

String readWindowsProjectVersion() =>
    _readBuildSettingsVersion(local_repo_paths.platform_windows);

String readLinuxProjectVersion() =>
    _readBuildSettingsVersion(local_repo_paths.platform_linux);

String _readBuildSettingsVersion(String platform_path) {
  var buildSettings =
      File(p.join(platform_path, 'build_settings.yaml')).readAsStringSync();
  var yaml = loadYaml(buildSettings) as YamlMap;
  return yaml['version'].toString();
}
