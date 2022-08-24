import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'paths.dart' as paths;
import 'utils.dart' as utils;
import 'package:monarch_io_utils/utils.dart';

/// Builds Monarch Platform binaries for each Flutter SDK
/// declared in local_settings.yaml.
void main() {
  print('''

### build_platform.dart
''');

  utils.createDirectoryIfNeeded(paths.out_ui);

  for (final flutter_sdk in utils.read_flutter_sdks()) {
    print('''
===============================================================================
Using flutter sdk at:
  $flutter_sdk
  Flutter version ${paths.get_flutter_version(flutter_sdk)}, ${paths.get_flutter_channel(flutter_sdk)} channel.
''');

    var out_ui_flutter_id = paths.out_ui_flutter_id(flutter_sdk);
    utils.createDirectoryIfNeeded(out_ui_flutter_id);

    {
      print('Running `flutter precache`...');
      var result = Process.runSync(paths.flutter_exe(flutter_sdk), ['precache'],
          runInShell: Platform.isWindows);
      utils.exitIfNeeded(result, 'Error running `flutter precache`');
    }

    if (Platform.isMacOS) {
      buildMacOs(out_ui_flutter_id, flutter_sdk);
    }

    if (Platform.isWindows) {
      buildWindows(out_ui_flutter_id, flutter_sdk);
    }

    print('''
===============================================================================
''');
  }

  var version = functionForPlatform(
      macos: readMacosProjectVersion, windows: readWindowsProjectVersion);
  version = utils.getVersionSuffix(version);
  utils.writeInternalFile('platform_app_version.txt', version);
  print('Monarch ${paths.os} platform build finished. Version $version');
}

void buildMacOs(String out_ui_flutter_id, String flutter_sdk) {
  const monarch_macos = 'monarch_macos';

  var ephemeral_dir = Directory(paths.platform_macos_ephemeral);
  if (ephemeral_dir.existsSync()) ephemeral_dir.deleteSync(recursive: true);
  ephemeral_dir.createSync(recursive: true);

  print('Copying darwin flutter framework bundle to ephemeral directory...');

  var result = Process.runSync('cp', [
    '-R',
    paths.darwin_flutter_framework(flutter_sdk),
    paths.platform_macos_ephemeral
  ]);
  utils.exitIfNeeded(result, 'Error copying darwin flutter framework bundle');

  var monarch_macos_app_dir =
      Directory(paths.out_ui_flutter_id_monarch_macos_app(out_ui_flutter_id));
  if (monarch_macos_app_dir.existsSync())
    monarch_macos_app_dir.deleteSync(recursive: true);

  print('''
Building $monarch_macos with xcodebuild. Will output to:
  ${paths.out_ui_flutter_id_monarch_macos_app(out_ui_flutter_id)}''');

  result = Process.runSync(
      'xcodebuild',
      [
        '-scheme',
        '$monarch_macos',
        'CONFIGURATION_BUILD_DIR=$out_ui_flutter_id',
        'build'
      ],
      workingDirectory: paths.platform_macos);
  utils.exitIfNeeded(result, 'Error running xcodebuild');

  var swiftmodule = Directory(p.join(out_ui_flutter_id, 'Monarch.swiftmodule'));
  if (swiftmodule.existsSync()) swiftmodule.deleteSync(recursive: true);
}

String readMacosProjectVersion() {
  var result = Process.runSync('xcodebuild', ['-showBuildSettings'],
      workingDirectory: paths.platform_macos);
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

String readWindowsProjectVersion() {
  var buildSettings =
      File(p.join(paths.platform_windows, 'build_settings.yaml'))
          .readAsStringSync();
  var yaml = loadYaml(buildSettings) as YamlMap;
  return yaml['version'].toString();
}

/// Builds the monarch_windows_app for the given [flutter_sdk].
///
/// For details on how the Monarch Windows build works see:
/// - file: platform/windows/README.md
/// - section: How the Monarch Windows build works
void buildWindows(String out_ui_flutter_id, String flutter_sdk) {
  var gen_seed_dir = Directory(
      paths.gen_seed_flutter_id(paths.platform_windows_gen_seed, flutter_sdk));
  if (_isGenSeedDirectoryOk(gen_seed_dir)) {
    /// Commands `flutter create` and `flutter build` are slow,
    /// thus when gen_seed directory is ok, do not re-run those commands.
    print('gen_seed for this flutter version ok.');
  } else {
    if (gen_seed_dir.existsSync()) {
      print('gen_seed found but not ok, will re-generate it.');
      gen_seed_dir.deleteSync(recursive: true);
    } else {
      print('gen_seed for this flutter version not found, will generate it.');
    }
    gen_seed_dir.createSync(recursive: true);
    print('Running `flutter create` in gen_seed...');

    /// Run `flutter create` and `flutter build`
    var result = Process.runSync(
        paths.flutter_exe(flutter_sdk),
        [
          'create',
          '.',
          '--project-name',
          'monarch_windows_app',
          '--platforms',
          'windows',
          '--template',
          'app',
          '--org',
          'Dropsource'
        ],
        workingDirectory: gen_seed_dir.path,
        runInShell: true);
    utils.exitIfNeeded(result, 'Error running `flutter create`');

    print('Running `flutter build` in gen_seed...');
    result = Process.runSync(
        paths.flutter_exe(flutter_sdk), ['build', 'windows', '--debug'],
        workingDirectory: gen_seed_dir.path, runInShell: true);
    utils.exitIfNeeded(result, 'Error running `flutter build`');

    // After `flutter build`, the ephemeral directory in
    // gen_seed/{flutter_id}/windows/flutter/ephemeral
    // should be there with the flutter windows dlls.
  }

  {
    print('Cleaning gen directory...');
    var gen_dir = Directory(paths.platform_windows_gen);
    if (gen_dir.existsSync()) gen_dir.deleteSync(recursive: true);
    gen_dir.createSync(recursive: true);
  }

  {
    print('Copying gen_seed/{flutter_id}/windows/* to gen directory...');
    var result = Process.runSync(
        'robocopy',
        [
          p.join(
              paths.gen_seed_flutter_id(
                  paths.platform_windows_gen_seed, flutter_sdk),
              'windows'),
          paths.platform_windows_gen,
          '*.*',
          "/E"
        ],
        runInShell: true);

    utils.exitIfNeeded(result, 'Error copying gen_seed to gen directory',
        successExitCodes: [0, 1]);
  }

  {
    print('Editing files in gen directory...');

    {
      /// Rename gen/runner/main.cpp to main_original.cpp
      var main_cpp = p.join(paths.platform_windows_gen, 'runner', 'main.cpp');
      var main_og_file = File(main_cpp);
      main_og_file
          .renameSync(p.join(main_og_file.parent.path, 'main_original.cpp'));
    }

    {
      /// Write version number and app icon in gen/runner/Runner.rc
      var runner_rc = p.join(paths.platform_windows_gen, 'runner', 'Runner.rc');
      var runner_rc_file = File(runner_rc);
      var contents = runner_rc_file.readAsStringSync();
      runner_rc_file
          .renameSync(p.join(runner_rc_file.parent.path, 'Runner_original.rc'));

      var buildSettings =
          File(p.join(paths.platform_windows, 'build_settings.yaml'))
              .readAsStringSync();
      var yaml = loadYaml(buildSettings) as YamlMap;
      var version = yaml['version'].toString();
      var versionCsv = version.replaceAll('.', ',');

      contents = _assertAndReplace(
          contents, r'resources\\app_icon.ico', yaml['app_icon_path']);
      contents = _assertAndReplace(
          contents, 'VERSION_AS_NUMBER 1,0,0', 'VERSION_AS_NUMBER $versionCsv');
      contents = _assertAndReplace(contents, 'VERSION_AS_STRING "1.0.0"',
          'VERSION_AS_STRING "$version"');

      File(runner_rc).writeAsStringSync(contents);
    }

    {
      /// In gen/runner/flutter_window.h, change private members to protected
      var flutter_window_h =
          p.join(paths.platform_windows_gen, 'runner', 'flutter_window.h');
      var flutter_window_h_file = File(flutter_window_h);
      var contents = flutter_window_h_file.readAsStringSync();
      contents = _assertAndReplace(contents, 'private:', 'protected:');
      flutter_window_h_file.writeAsStringSync(contents);
    }
  }

  {
    print('Including src files in CMakeLists.txt...');
    var cmakelists_txt =
        p.join(paths.platform_windows_gen, 'runner', 'CMakeLists.txt');
    var cmakelists_og_file = File(cmakelists_txt);
    var cmakelistsContents = cmakelists_og_file.readAsStringSync();
    cmakelists_og_file.renameSync(
        p.join(cmakelists_og_file.parent.path, 'CMakeLists_original.txt'));

    var src_dir = Directory(paths.platform_windows_src);
    var srcFiles = src_dir.listSync(recursive: true, followLinks: false);
    srcFiles = srcFiles.where(_isSourceFile).toList();
    var buffer = StringBuffer();
    for (var srcFile in srcFiles) {
      var _path = p.relative(srcFile.path,
          from: p.join(paths.platform_windows_gen, 'runner'));
      _path = _path.replaceAll(r'\', r'/');
      buffer.writeln('  "$_path"');
    }

    cmakelistsContents = _assertAndReplace(
        cmakelistsContents, '"main.cpp"', buffer.toString().trim());
    File(cmakelists_txt).writeAsStringSync(cmakelistsContents);
  }

  {
    print('Generating Visual Studio build system using CMake...');
    var result = Process.runSync(
        'cmake.exe',
        [
          '-S',
          'gen',
          '-B',
          p.join('build', paths.flutter_id(flutter_sdk)),
          '-G',
          'Visual Studio 16 2019'
        ],
        workingDirectory: paths.platform_windows,
        runInShell: true);

    utils.exitIfNeededCMake(
        result, 'CMake error generating Visual Studio build system');

    // The build/{flutter_id} directory should now be set up.
  }

  {
    print('Building project using CMake...');
    var result = Process.runSync(
        'cmake.exe',
        [
          '--build',
          p.join('build', paths.flutter_id(flutter_sdk)),
          '--config',
          'Debug',
          '--target',
          'INSTALL',
          '--verbose'
        ],
        workingDirectory: paths.platform_windows,
        runInShell: true);

    utils.exitIfNeededCMake(result, 'CMake error building project');

    // The build/{flutter_id}/runner/Debug/* files should be created,
    // those files can be copied to the out directory
  }

  {
    print('Copying executable files to out directory...');
    var debug = p.join(paths.platform_windows_build,
        paths.flutter_id(flutter_sdk), 'runner', 'Debug');

    var result = Process.runSync(
        'copy', [p.join(debug, 'flutter_windows.dll'), out_ui_flutter_id],
        runInShell: true);
    utils.exitIfNeeded(
        result, 'Error copying flutter_windows.dll to out directory');

    result = Process.runSync(
        'copy', [p.join(debug, 'monarch_windows_app.exe'), out_ui_flutter_id],
        runInShell: true);
    utils.exitIfNeeded(
        result, 'Error copying monarch_windows_app.exe to out directory');

    result = Process.runSync(
        'copy', [p.join(debug, 'data', 'icudtl.dat'), out_ui_flutter_id],
        runInShell: true);
    utils.exitIfNeeded(result, 'Error copying icudtl.dat to out directory');

    result = Process.runSync('copy',
        [paths.windows_flutter_windows_pdb(flutter_sdk), out_ui_flutter_id],
        runInShell: true);
    utils.exitIfNeeded(
        result, 'Error copying flutter_windows.dll.pdb to out directory');
  }
}

bool _isGenSeedDirectoryOk(Directory gen_seed_dir) {
  if (!gen_seed_dir.existsSync()) {
    return false;
  }

  var windows_dir = Directory(p.join(gen_seed_dir.path, 'windows'));
  if (!windows_dir.existsSync()) {
    return false;
  }

  var build_dir = Directory(p.join(gen_seed_dir.path, 'build'));
  if (!build_dir.existsSync()) {
    return false;
  }

  if (windows_dir.listSync().isEmpty) {
    return false;
  }

  if (build_dir.listSync().isEmpty) {
    return false;
  }

  return true;
}

/// Returns source files which should be included in CMakeLists.txt
bool _isSourceFile(FileSystemEntity element) {
  return element is File && p.extension(element.path) == '.cpp';
}

String _assertAndReplace(String contents, String from, String to) {
  var matches = from.allMatches(contents);
  if (matches.length != 1) {
    print('Expected to find 1 match for $from - got ${matches.length}');
    exit(1);
  }
  return contents.replaceFirst(from, to);
}
