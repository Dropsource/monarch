import 'dart:io';

import 'package:monarch_utils/log.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import '../config/project_config.dart';
import '../config/monarch_package_compatibility.dart';
import '../utils/cli_exit_code.dart';
import '../utils/managed_process.dart';
import '../utils/standard_output.dart';
import 'pubspec_editor.dart';
import 'build_yaml_editor.dart';
import 'package:path/path.dart' as p;
import 'init_exit_codes.dart';

const devDependencies = 'dev_dependencies';

class Initializer extends LongRunningCli<CliExitCode> with Log {
  final ProjectConfig projectConfig;
  final MonarchPackageCompatibility monarchPackageCompatibility;

  Initializer(this.projectConfig)
      : monarchPackageCompatibility =
            MonarchPackageCompatibility(projectConfig.flutterSdkId.version);

  @override
  void didRun() {
    _initialize();
  }

  @override
  CliExitCode get userTerminatedExitCode => CliExitCodes.userTerminated;

  @override
  Future<void> willTerminate() async {
    _flutterPubGet?.terminate();
  }

  ManagedProcess? _flutterPubGet;

  void _initialize() async {
    final errors = <String>[];

    stdout_default.writeln(
        '## Initializing ${projectConfig.pubspecProjectName} with Monarch');

    try {
      stdout_default
          .writeln('Adding dev_dependencies `monarch` and `build_runner`...');
      await _addDevDependencies();
    } catch (e, s) {
      log.severe('Error adding dev_dependencies', e, s);
      errors.add('''
Error adding monarch packages to the project's pubspec.yaml.
Please add the following packages manually to your pubspec.yaml dev_dependencies:

$devDependencies
  monarch: ^${monarchPackageCompatibility.monarchPackageInitVersion}
  build_runner: ^${monarchPackageCompatibility.buildRunnerPackageInitVersion}
''');
    }

    try {
      stdout_default.writeln('Setting up build.yaml...');
      await _setUpBuildYaml();
    } catch (e, s) {
      log.severe('Error setting up build.yaml', e, s);
      errors.add(r'''
Error setting up build.yaml file.
Please create a build.yaml file at the top level of your project and add the following:

targets:
  $default:
    sources:
      - $package$
      - lib/**
      - stories/**
''');
    }

    try {
      stdout_default.writeln('Creating sample stories in stories directory...');
      await _setUpSampleStories();
    } catch (e, s) {
      log.severe('Error setting up stories directory or sample files', e, s);
      errors.add('''
Error creating the sample stories in the stories directory.
Refer to the monarch documentation on how to get started.
''');
    }

    try {
      stdout_default.writeln('Adding .monarch directory to .gitignore...');
      await _gitIgnoreDotMonarchDirectory();
    } catch (e, s) {
      log.warning('Error adding .monarch to .gitignore', e, s);
      errors.add('''
Error adding .monarch directory to .gitignore. 
You can add it manually by adding the following to your .gitignore file:
.monarch/
''');
    }

    try {
      // default_stdout.writeln('Running `flutter pub get`...');
      _flutterPubGet = FlutterPubGet(
          projectDirectory: projectConfig.projectDirectory,
          flutterExecutablePath: projectConfig.flutterExecutablePath);
      await _flutterPubGet!.start();
      await _flutterPubGet!.done();
    } on ProcessTerminatedException {
      errors.add('`flutter pub get` terminated');
      finish(CliExitCodes.userTerminated);
    } on ProcessFailedException {
      // any `flutter pub get` errors should already be printed out to terminal
      errors.add('Error running `flutter pub get`.');
    } catch (e, s) {
      log.severe('Unexpected error running `flutter pub get`', e, s);
      errors.add('''
Unexpected error running `flutter pub get`.
$e
''');
    }

    stdout_default.writeln();
    if (errors.isEmpty) {
      stdout_default.write('''
Monarch successfully initialized in this project.

Now you can: 
- run Monarch using "monarch run" to see a few sample stories, or 
- write your first story (https://monarchapp.io/docs/write-first-story).

''');
      return finish(InitExitCodes.success);
    } else {
      stdout_default
          .writeln('There were some errors during Monarch initialization:');
      for (var error in errors) {
        stdout_default.write('''
===============================================================================
$error
===============================================================================
''');
      }
      return finish(InitExitCodes.someErrors);
    }
  }

  Future<void> _addDevDependencies() async {
    final pubspec = await projectConfig.pubspecFile.readAsString();

    final editor = PubspecEditor(pubspec);
    editor.setPackage(devDependencies, 'monarch',
        '^${monarchPackageCompatibility.monarchPackageInitVersion}');
    editor.setPackage(devDependencies, 'build_runner',
        '^${monarchPackageCompatibility.buildRunnerPackageInitVersion}');

    await projectConfig.pubspecFile.writeAsString(editor.newContents);
  }

  Future<void> _setUpBuildYaml() async {
    final path = p.join(projectConfig.projectDirectory.path, 'build.yaml');
    final file = File(path);
    await _writeFileIfMissing(file, '', flush: true);
    final contents = await file.readAsString();

    final editor = BuildYamlEditor(contents);
    editor.setDefaultTargetSources([r'$package$', 'lib/**', 'stories/**']);
    await file.writeAsString(editor.newContents);
  }

  Future<void> _setUpSampleStories() async {
    final storiesDir =
        Directory(p.join(projectConfig.projectDirectory.path, 'stories'));
    if (!await storiesDir.exists()) {
      await storiesDir.create();
    }

    final sampleWidgetFile =
        File(p.join(storiesDir.path, 'sample_button.dart'));
    final sampleStoriesFile =
        File(p.join(storiesDir.path, 'sample_button_stories.dart'));

    await _writeFileIfMissing(sampleWidgetFile, sampleButtonWidgetSourceCode);
    await _writeFileIfMissing(sampleStoriesFile, sampleButtonStoriesSourceCode);
  }

  Future<void> _gitIgnoreDotMonarchDirectory() async {
    final gitIgnoreFile =
        File(p.join(projectConfig.projectDirectory.path, '.gitignore'));
    if (await gitIgnoreFile.exists()) {
      final contents = await gitIgnoreFile.readAsString();
      if (!contents.contains(RegExp(r'^.monarch$'))) {
        const contentToAppend = '''

# Monarch related
.monarch/
''';
        await gitIgnoreFile.writeAsString(contentToAppend,
            mode: FileMode.append);
      }
    }
  }

  Future<void> _writeFileIfMissing(File file, String contents,
      {bool flush = false}) async {
    if (!await file.exists()) {
      await file.writeAsString(contents, flush: flush);
    }
  }
}

class InitCommandException implements Exception {}

const sampleButtonWidgetSourceCode = '''
import 'package:flutter/material.dart';

enum ButtonStyles { primary, secondary, disabled }

class Button extends StatelessWidget {
  final String text;
  final ButtonStyles style;

  const Button(this.text, this.style, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () => {},
            style: TextButton.styleFrom(
                foregroundColor: getPrimaryColor(),
                backgroundColor: getBackgroundColor(),
                side: style == ButtonStyles.secondary
                    ? const BorderSide(width: 0, color: Colors.black87)
                    : null),
            child: Text(text)));
  }

  Color getPrimaryColor() {
    switch (style) {
      case ButtonStyles.primary:
        return Colors.white;
      case ButtonStyles.secondary:
        return Colors.black87;
      case ButtonStyles.disabled:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Color getBackgroundColor() {
    switch (style) {
      case ButtonStyles.primary:
        return Colors.green;
      case ButtonStyles.secondary:
        return Colors.white;
      case ButtonStyles.disabled:
        return const Color(0xFFE0E0E0);
      default:
        return Colors.green;
    }
  }
}
''';

const sampleButtonStoriesSourceCode = '''
import 'package:flutter/material.dart';
import 'sample_button.dart';

Widget primary() => const Button('Button', ButtonStyles.primary);

Widget secondary() => const Button('Button', ButtonStyles.secondary);

Widget disabled() => const Button('Button', ButtonStyles.disabled);
''';
