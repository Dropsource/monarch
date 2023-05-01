import 'dart:io';

import 'package:args/command_runner.dart';

import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;
import 'paths.dart';

import 'build_cli.dart';
import 'build_controller.dart';
import 'build_platform.dart';
import 'build_preview_api.dart';
import 'clean.dart';

void main(List<String> arguments) async {
  var runner = CommandRunner('build',
      'Builds Monarch and its modules. By default it will build to the out directory.')
    ..addCommand(CleanCommand())
    ..addCommand(BuildControllerCommand())
    ..addCommand(BuildPlatformCommand())
    ..addCommand(BuildPreviewApiCommand())
    // ..addCommand(BuildInternalCommand())  // NEXT: implement and rename to build.dart
    ..addCommand(BuildAllCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e);
    exit(1);
  }
}

class BuildAllCommand extends Command {
  @override
  String get description => 'Builds all the Monarch modules to the out directory using the Flutter SDKs declared in local_settings.yaml.';

  @override
  String get name => 'all';

  @override
  Future<void> run() async {
    await CleanCommand().run();
    await BuildCliCommand().run();
    await BuildControllerCommand().run();
    await BuildPreviewApiCommand().run();
    await BuildPlatformCommand().run();
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

  @override
  Future<void> run() async {
    buildCli();
  }
} 

abstract class BuildWithFlutterCommand extends Command {
  BuildWithFlutterCommand() {
    argParser.addOption('flutter-sdk',
        abbr: 'f',
        help:
            'Path to the Flutter SDK to use. If blank, this command will run using '
            'each Flutter SDK declared in local_settings.yaml.');
    argParser.addOption('out-ui',
        abbr: 'o',
        help:
            'Path to the monarch_ui/{flutter_id} output directory. Required if --flutter-sdk is set.');
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
      String? out_ui_flutter_id_ = argResults!['out-ui'];
      if (out_ui_flutter_id_ == null) {
        throw '--out-ui must be provided if --flutter-sdk is set';
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
  String get description => 'Builds the Monarch Platform for the current operating system.';

  @override
  String get name => 'platform';

  @override
  void buildWithFlutter(
      String repo_root, String flutter_sdk, String out_ui_flutter_id) {
    buildPlatform(repo_root, flutter_sdk, out_ui_flutter_id);
  }
}
