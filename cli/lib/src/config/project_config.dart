import 'dart:async';
import 'dart:io';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:monarch_utils/log.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:pub_semver/pub_semver.dart' as pub;

import '../config/flutter_version_parser.dart';
import '../utils/standard_output.dart';
import 'package_config_helper.dart';
import 'lockfile_parser.dart';
import 'validator.dart';
import 'internal_info.dart';

const pubspecFileName = 'pubspec.yaml';
const kFlutter = 'flutter';

class LockfilePackagesOfInterest {
  static const monarch = 'monarch';
  static const monarchAnnotations = 'monarch_annotations';
  static const buildRunner = 'build_runner';

  static const list = [buildRunner, monarch, monarchAnnotations];
}

class ProjectConfigStateError extends StateError {
  ProjectConfigStateError.getterNotNull(String getterName)
      : super(
            '$getterName is null, make sure isValid equals true before calling this getter');
}

class ProjectConfig extends Validator with Log {
  final Directory projectDirectory;
  final InternalInfo internalInfo;

  ProjectConfig(this.projectDirectory, this.internalInfo)
      : _packageConfigHelper = PackageConfigHelper(projectDirectory);

  File get pubspecFile => File(p.join(projectDirectory.path, pubspecFileName));

  String? _flutterExecutablePath;
  String get flutterExecutablePath {
    if (_flutterExecutablePath == null) {
      throw ProjectConfigStateError.getterNotNull('flutterExecutablePath');
    }
    return _flutterExecutablePath!;
  }

  String? _dartExecutablePath;
  String get dartExecutablePath {
    if (_dartExecutablePath == null) {
      throw ProjectConfigStateError.getterNotNull('dartExecutablePath');
    }
    return _dartExecutablePath!;
  }

  String get flutterSdkBinDirectory => p.dirname(flutterExecutablePath);
  String get flutterSdkDirectory => p.dirname(flutterSdkBinDirectory);

  FlutterSdkId? _flutterSdkId;
  FlutterSdkId get flutterSdkId {
    if (_flutterSdkId == null) {
      throw ProjectConfigStateError.getterNotNull('flutterSdkId');
    }
    return _flutterSdkId!;
  }

  String? _pubspecProjectName;
  String get pubspecProjectName {
    if (_pubspecProjectName == null) {
      throw ProjectConfigStateError.getterNotNull('pubspecName');
    }
    return _pubspecProjectName!;
  }

  final PackageConfigHelper _packageConfigHelper;
  late LockfileParser _lockfileParser;

  @override
  Future<void> validate() async {
    final errors = <String>[];

    log.fine('Loading project config with path ${projectDirectory.path}');

    await _validateKeyProjectFiles(errors);
    await _setLockfileParser(errors);

    if (errors.isEmpty) {
      await _setFlutterExecutablePath(errors);
      await _setPubspecProjectName(errors);
    }

    if (errors.isEmpty) {
      stdout_default.writeln('Using flutter sdk at $flutterExecutablePath');
      await _setFlutterSdkId(errors);
    }

    if (errors.isEmpty) {
      _validateFlutterVersionSupport(errors);
    }

    validationErrors.addAll(errors);
  }

  Future<void> _validateKeyProjectFiles(List<String> errors) async {
    if (!await projectDirectory.exists()) {
      errors.add('project directory does not exist');
    }
    if (!await pubspecFile.exists()) {
      errors.add(
          'Could not find pubspec.yaml, make sure this is a flutter project directory');
    }
    await _packageConfigHelper.setUp();
    if (!_packageConfigHelper.packageConfigExists) {
      errors.add(
          'Could not find .dart_tool/package_config.json file, make sure to run `flutter pub get` first');
    }
    if (_packageConfigHelper.hasParsingError) {
      errors.add('Could not parse .dart_tool/package_config.json file.');
    }
  }

  Future<void> _setLockfileParser(List<String> errors) async {
    try {
      _lockfileParser =
          LockfileParser(projectDirectory, LockfilePackagesOfInterest.list);
      await _lockfileParser.parseAndPopulatePackagesMap();
    } catch (err, s) {
      log.warning('Error while parsing lockfile pubspec.lock.', err, s);
      errors.add('Could not parse lockfile pubspec.lock.');
    }
  }

  Future<void> _setFlutterExecutablePath(List<String> errors) async {
    if (!_packageConfigHelper.hasPackage(kFlutter)) {
      errors.add(
          'Could not find flutter sdk path in .dart_tool/package_config.json file');
      return;
    }

    final helper =
        FlutterPackageHelper(_packageConfigHelper.getPackageRootPath(kFlutter));

    if (!helper.endsWithTrailingDirs) {
      errors.add(
          'Root path of flutter package in .dart_tool/package_config.json file does not end as expected');
      return;
    }

    _flutterExecutablePath = helper.getFlutterExePath();
    if (!await File(flutterExecutablePath).exists()) {
      errors.add('Flutter executable not found at $flutterExecutablePath');
      return;
    }
    log.info('Found flutter executable at $flutterExecutablePath');

    _dartExecutablePath = helper.getDartExePath();
    if (!await File(dartExecutablePath).exists()) {
      errors.add('Dart executable not found at $dartExecutablePath');
      return;
    }
    log.info('Found dart executable at $dartExecutablePath');
  }

  Future<void> _setFlutterSdkId(List<String> errors) async {
    try {
      var parser = FlutterVersionParser(flutterExecutablePath);
      _flutterSdkId = await parser.getFlutterSdkId();
      log.info(
          'flutter_version=${flutterSdkId.version} flutter_channel=${flutterSdkId.channel}');
    } catch (e, s) {
      log.warning('Error while getting or parsing flutter sdk id', e, s);
      errors.add(
          'Could not determine flutter version or channel from command `flutter --version`');
    }
  }

  void _validateFlutterVersionSupport(List<String> errors) {
    try {
      var minimumFlutter = pub.Version.parse(internalInfo.minFlutterVersion);
      var projectFlutter = pub.Version.parse(flutterSdkId.version);
      if (minimumFlutter <= projectFlutter) {
        log.info(
            'min_flutter_version=${internalInfo.minFlutterVersion} flutter version support ok');
      } else {
        log.info(
            'min_flutter_version=${internalInfo.minFlutterVersion} flutter version support not ok');
        errors.add(
            'The Flutter version this project is using is not supported by this version of Monarch. '
            'The minimum Flutter version supported by Monarch is ${internalInfo.minFlutterVersion}. '
            'Please upgrade your Flutter version to use Monarch.');
      }
    } catch (e, s) {
      log.warning('Error parsing flutter version', e, s);
      errors.add('Could not determine flutter version support');
    }
  }

  Future<void> _setPubspecProjectName(List<String> errors) async {
    final pubspecContents = await pubspecFile.readAsString();

    try {
      final pubspec = Pubspec.parse(pubspecContents, lenient: true);
      _pubspecProjectName = pubspec.name;
    } on ParsedYamlException catch (err) {
      errors.add('Could not parse pubspec.yaml: ${err.message}');
    }
  }

  @override
  String get foundErrorsMessage => 'Found configuration errors';
}

class TaskRunnerProjectConfig extends ProjectConfig {
  TaskRunnerProjectConfig(Directory projectDirectory, InternalInfo internalInfo)
      : super(projectDirectory, internalInfo);

  pub.Version? _monarchPackageVersion;
  pub.Version get monarchPackageVersion {
    if (_monarchPackageVersion == null) {
      throw ProjectConfigStateError.getterNotNull('monarchPackageVersion');
    }
    return _monarchPackageVersion!;
  }

  @override
  Future<void> validate() async {
    await super.validate();

    final errors = <String>[];

    if (isValid) {
      errors.addAll(await _validateMonarchPackagesInLockfile());
    }

    validationErrors.addAll(errors);
  }

  Future<List<String>> _validateMonarchPackagesInLockfile() async {
    final errors = <String>[];
    final monarchInitQuestion = 'Did you run `monarch init`?';

    if (!_lockfileParser.packagesMap
        .containsKey(LockfilePackagesOfInterest.monarch)) {
      errors.add(
          'Could not find monarch package in pubspec.lock. $monarchInitQuestion');
    } else if (!_lockfileParser.packagesMap
        .containsKey(LockfilePackagesOfInterest.buildRunner)) {
      errors.add(
          'Could not find build_runner package in pubspec.lock. $monarchInitQuestion');
    }

    if (errors.isEmpty) {
      final packageInfo =
          _lockfileParser.packagesMap[LockfilePackagesOfInterest.monarch]!;
      _monarchPackageVersion = packageInfo.version;
      log.info('monarch_package_version=$_monarchPackageVersion');
    }

    return errors;
  }
}
