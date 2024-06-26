import 'dart:io';
import 'package:io/io.dart';

import 'package:args/command_runner.dart';

import 'package:monarch_cli/execute_init.dart';
import 'package:monarch_cli/execute_newsletter.dart';
import 'package:monarch_cli/execute_task_runner.dart';
import 'package:monarch_cli/execute_upgrade.dart';
import 'package:monarch_cli/version_printer.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

const $verbose = 'verbose';
const $crashDebug = 'crash-debug';

/// @GOTCHA: if you modify the cli commands descriptions, arguments or help text,
/// then the docs on the website (/docs/cli-usage) need to be updated.
/// See bin/cli_usage_doc.dart
final runner = CommandRunner(
    'monarch', 'CLI to run Monarch binaries, stories and other related tasks.')
  ..argParser.addFlag($verbose,
      abbr: 'v',
      negatable: false,
      help: 'Generates verbose logs.',
      defaultsTo: false)
  ..argParser.addFlag('version',
      negatable: false, help: 'Reports Monarch version information.')
  ..addCommand(InitCommand())
  ..addCommand(RunCommand())
  ..addCommand(UpgradeCommand())
  ..addCommand(NewsletterCommand());

void main(List<String> arguments) async {
  try {
    if (arguments.contains('--version')) {
      await printVersion();
    } else {
      await runner.run(arguments);
    }
  } on UsageException catch (e) {
    print(e);
    exit(ExitCode.usage.code);
  }
}

class InitCommand extends Command {
  @override
  String get description => 'Initializes a Flutter project with Monarch.';

  @override
  String get name => 'init';

  InitCommand() {
    argParser.addFlag($crashDebug, defaultsTo: false, hide: true);
  }

  @override
  Future<void> run() async {
    final bool isVerbose = globalResults![$verbose];
    final bool isCrashDebug = argResults![$crashDebug];

    executeInit(isVerbose, isCrashDebug);
  }
}

class RunCommand extends Command {
  @override
  String get description =>
      'Runs the Monarch tasks and launches the Monarch desktop app.';

  @override
  String get name => 'run';

  RunCommand() {
    argParser
      ..addFlag($crashDebug, defaultsTo: false, hide: true)
      ..addSeparator('')
      ..addOption('reload',
          defaultsTo: 'hot-reload',
          allowed: ['hot-reload', 'hot-restart', 'manual'],
          help: 'How Monarch should reload stories after file system updates.',
          allowedHelp: {
            'hot-reload': 'Reload stories automatically with hot reload.',
            'hot-restart': 'Reload stories automatically with hot restart.',
            'manual': hardWrap(
                'Don\'t reload automatically. Manually reload stories with '
                'hot reload ("r") or hot restart ("R"). Does not watch the '
                'file system for updates.')
          })
      ..addFlag('delete-conflicting-outputs',
          defaultsTo: false,
          negatable: false,
          help: hardWrap(
              'When set, it passes the --delete-conflicting-outputs flag to the '
              'build_runner code generation.'))
      ..addFlag('no-sound-null-safety',
          defaultsTo: false,
          negatable: false,
          help: hardWrap(
              'When set, Monarch will generate stories that support non-null safe '
              'libraries. Use this flag if your code has disabled sound null safety.'))
      ..addOption('discovery-api-port',
          help: hardWrap(
              'The port for the Monarch Discovery API. Used for testing.'));
  }

  @override
  Future<void> run() async {
    final bool isVerbose = globalResults![$verbose];
    final bool isCrashDebug = argResults![$crashDebug];
    final bool isDeleteConflictingOutputs =
        argResults!['delete-conflicting-outputs'];
    final bool noSoundNullSafety = argResults!['no-sound-null-safety'];
    final String reload = argResults!['reload'];
    final String? discoveryApiPortString = argResults!['discovery-api-port'];

    int? discoveryApiPort;
    if (discoveryApiPortString != null) {
      try {
        discoveryApiPort = int.parse(discoveryApiPortString);
      } on FormatException {
        throw 'Could not parse --discovery-api-port';
      }
    }

    executeTaskRunner(
        isVerbose: isVerbose,
        isCrashDebug: isCrashDebug,
        isDeleteConflictingOutputs: isDeleteConflictingOutputs,
        noSoundNullSafety: noSoundNullSafety,
        reloadOption: reload,
        discoveryApiPort: discoveryApiPort);
  }
}

class UpgradeCommand extends Command {
  @override
  String get description => 'Upgrades Monarch to its latest version.';

  @override
  String get name => 'upgrade';

  UpgradeCommand() {
    argParser
      ..addFlag($crashDebug, defaultsTo: false, hide: true)
      ..addFlag('windows-second-pass', defaultsTo: false, hide: true)
      ..addOption('monarch-exe', hide: true);
  }

  @override
  Future<void> run() async {
    final bool isVerbose = globalResults![$verbose];
    final bool isCrashDebug = argResults![$crashDebug];

    if (Platform.isWindows) {
      final bool isWindowsSecondPass = argResults!['windows-second-pass'];
      if (isWindowsSecondPass) {
        final String monarchExe = argResults!['monarch-exe'];
        executeUpgrade(isVerbose, isCrashDebug, monarchExe);
      } else {
        executeWindowsUpgradeFirstPass(isVerbose, isCrashDebug);
      }
    } else {
      executeUpgrade(isVerbose, isCrashDebug, null);
    }
  }
}

class NewsletterCommand extends Command {
  @override
  String get description =>
      'Join the Monarch newsletter by providing an email.';

  @override
  String get name => 'newsletter';

  @override
  Future<void> run() async {
    final bool isVerbose = globalResults![$verbose];
    final isCrashDebug = false;

    executeJoinNewsletter(isVerbose, isCrashDebug);
  }
}
