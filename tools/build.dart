import 'dart:io';

import 'package:args/command_runner.dart';

import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;
import 'paths.dart';

import 'clean.dart';
import 'build_cli.dart';
import 'build_controller.dart';
import 'build_platform.dart';
import 'build_preview_api.dart';
import 'build_internal.dart';

/// Build all Monarch modules on your local to the out directory:
///
///   $ dart tools/build.dart all
///
/// You can also build a specific Monarch module:
///
///   $ dart tools/build.dart cli
///   $ dart tools/build.dart controller
///
/// To get more details:
///
///   $ dart tools/build.dart -h
void main(List<String> arguments) async {
  var runner = CommandRunner('build',
      'Builds Monarch and its modules. By default it will build to the out directory.')
    ..addCommand(BuildAllCommand())
    ..addCommand(CleanCommand())
    ..addCommand(BuildCliCommand())
    ..addCommand(BuildControllerCommand())
    ..addCommand(BuildPlatformCommand())
    ..addCommand(BuildPreviewApiCommand())
    ..addCommand(BuildInternalCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e);
    exit(1);
  }
}

class BuildAllCommand extends Command {
  @override
  String get description =>
      'Builds all the Monarch modules to the out directory using the Flutter SDKs declared in local_settings.yaml.';

  @override
  String get name => 'all';

  @override
  Future<void> run() async {
    await CleanCommand().run();
    await BuildCliCommand().run();
    await BuildControllerCommand().run();
    await BuildPreviewApiCommand().run();
    await BuildPlatformCommand().run();
    await BuildInternalCommand().run();
  }
}

class CleanCommand extends Command {
  @override
  String get description => 'Deletes and re-creates Monarch build directories.';

  @override
  String get name => 'clean';

  @override
  Future<void> run() async {
    clean();
  }
}

class BuildCliCommand extends Command {
  @override
  String get description => 'Builds the Monarch CLI';

  @override
  String get name => 'cli';

  BuildCliCommand() {
    argParser.addOption('out-monarch-bin',
        help: 'Path to the monarch bin directory. '
            'Defaults to out/monarch/bin.');
  }

  @override
  Future<void> run() async {
    var monarchBin = argResults?['out-monarch-bin'] ?? local_out_paths.out_bin;
    buildCli(monarchBin);
  }
}

abstract class BuildWithFlutterCommand extends Command {
  BuildWithFlutterCommand() {
    argParser.addOption('flutter-sdk',
        abbr: 'f',
        help:
            'Path to the Flutter SDK to use. If blank, this command will run using '
            'each Flutter SDK declared in local_settings.yaml. '
            'And it will output to the out/monarch/bin/cache/monarch_ui directory.');
    argParser.addOption('out-monarch-ui-flutter-id',
        help: 'Path to the monarch_ui/{flutter-id} directory. '
            'Only used when flutter-sdk is set.');
  }

  @override
  Future<void> run() async {
    if (argResults?['flutter-sdk'] == null) {
      utils.createDirectoryIfNeeded(local_out_paths.out_ui);

      for (final flutter_sdk in local_utils.read_flutter_sdks()) {
        var out_ui_flutter_id_ =
            out_ui_flutter_id(local_out_paths.out_ui, flutter_sdk);
        utils.createDirectoryIfNeeded(out_ui_flutter_id_);
        buildWithFlutter(
            local_repo_paths.root, flutter_sdk, out_ui_flutter_id_);
      }
    } else {
      String flutter_sdk = argResults!['flutter-sdk'];
      String? out_ui_flutter_id_ = argResults!['out-monarch-ui-flutter-id'];
      if (out_ui_flutter_id_ == null) {
        throw '--out-monarch-ui-flutter-id must be provided if --flutter-sdk is set';
      }
      buildWithFlutter(local_repo_paths.root, flutter_sdk, out_ui_flutter_id_);
    }
  }

  void buildWithFlutter(
      String repo_root, String flutter_sdk, String out_ui_flutter_id);
}

class BuildControllerCommand extends BuildWithFlutterCommand {
  @override
  String get description => 'Builds the Monarch Controller.';

  @override
  String get name => 'controller';

  @override
  void buildWithFlutter(
      String repo_root, String flutter_sdk, String out_ui_flutter_id) {
    buildController(repo_root, flutter_sdk, out_ui_flutter_id);
  }
}

class BuildPreviewApiCommand extends BuildWithFlutterCommand {
  @override
  String get description => 'Builds the Monarch Preview API.';

  @override
  String get name => 'preview_api';

  @override
  void buildWithFlutter(
      String repo_root, String flutter_sdk, String out_ui_flutter_id) {
    buildPreviewApi(repo_root, flutter_sdk, out_ui_flutter_id);
  }
}

class BuildPlatformCommand extends BuildWithFlutterCommand {
  @override
  String get description =>
      'Builds the Monarch Platform for the current operating system.';

  @override
  String get name => 'platform';

  @override
  void buildWithFlutter(
      String repo_root, String flutter_sdk, String out_ui_flutter_id) {
    buildPlatform(repo_root, flutter_sdk, out_ui_flutter_id);
  }
}

class BuildInternalCommand extends Command {
  @override
  String get description =>
      'Writes monarch/bin/internal files, such as version and revision files.';

  @override
  String get name => 'internal';

  BuildInternalCommand() {
    argParser.addOption('internal-dir',
        help:
            'Path to the internal directory to write to. Defaults to out/bin/internal.');
    argParser.addOption('binaries-version',
        help: 'The version of the Monarch binaries. Defaults to "local".');
    argParser.addOption('revision',
        help:
            'The revision git hash. If blank, this script will use `git rev-parse` '
            'to find the HEAD revision.');
    argParser.addOption('min-flutter-version',
        help: 'The minimum Flutter verison supported by this Monarch build. '
            'Defaults to "3.0.0"');
  }

  @override
  Future<void> run() async {
    String internal_ =
        argResults?['internal-dir'] ?? local_out_paths.out_bin_internal;
    String binariesVersion = argResults?['binaries-version'] ?? 'local';
    String minFlutterVersion = argResults?['min-flutter-version'] ?? '3.0.0';

    writeInternalFiles(
        internal_, binariesVersion, minFlutterVersion, argResults?['revision']);
  }
}
