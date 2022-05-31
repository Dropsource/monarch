import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart' as paths;
import 'utils.dart' as utils;

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

  if (Platform.isMacOS) {
    var version = readMacosProjectVersion();
    version = utils.getVersionSuffix(version);
    utils.writeInternalFile('platform_app_version.txt', version);
    print('Monarch macos platform build finished. Version $version');
  }
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

  var swiftmodule =
      Directory(p.join(out_ui_flutter_id, '$monarch_macos.swiftmodule'));
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

void buildWindows(out_ui_flutter_id, flutter_sdk) {
  var gen_seed_dir = Directory(
      paths.gen_seed_flutter_id(paths.platform_windows_gen_seed, flutter_sdk));
  if (gen_seed_dir.existsSync()) {
    // do nothing, assume directory is set up correctly to speed up local builds
    // run clean.dart to clean gen_seed directory
    print('gen_seed for this flutter version already created.');
  } else {
    print('Running `flutter create` in gen_seed...');
    // run `flutter create` and `flutter build`
    gen_seed_dir.createSync(recursive: true);
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
          'app'
        ],
        workingDirectory: gen_seed_dir.path,
        runInShell: true);
    utils.exitIfNeeded(result, 'Error running `flutter create`');

    print('Running `flutter build` in gen_seed...');
    result = Process.runSync(
        paths.flutter_exe(flutter_sdk), ['build', 'windows', '--debug'],
        workingDirectory: gen_seed_dir.path, runInShell: true);
    utils.exitIfNeeded(result, 'Error running `flutter build`');
  }

  {
    print('Cleaning gen directory...');
    var gen_dir = Directory(paths.platform_windows_gen);
    if (gen_dir.existsSync()) gen_dir.deleteSync(recursive: true);
    gen_dir.createSync(recursive: true);
  }

  {
    print('Copying gen_seed windows source files to gen directory...');
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
    var main_cpp = p.join(paths.platform_windows_gen, 'runner', 'main.cpp');
    var main_og_file = File(main_cpp);
    main_og_file
        .renameSync(p.join(main_og_file.parent.path, 'main_original.cpp'));
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

    cmakelistsContents =
        cmakelistsContents.replaceFirst('"main.cpp"', buffer.toString().trim());
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

    utils.exitIfNeededCheckStderr(
        result, 'cmake error generating Visual Studio build system');
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

    utils.exitIfNeededCheckStderr(result, 'cmake error building project');
  }

  // cp -R .\gen_seed\flutter_windows_3.0.1-stable\windows\* .\gen_x\

// if gen_seed/{flutter_sdk} does not exists, then create it and:
//   in monarch/platform/windows/gen_seed/{flutter_sdk}
// cmd: flutter create . --project-name monarch_windows_app --platforms windows --template app
// cmd: flutter build windows --debug
//   now ephemeral and generated source files should be there

// if gen_seed/{flutter_sdk} exists then do nothing, this process is slow thus we
//   don't want to re-create and re-build it with every build
//   run clean.dart if you want to re-build gen_seed

// clean gen dir
// then copy gen_seed/{flutter_sdk}/windows/* to monarch/platform/windows/gen

// then rename gen/runner/main.cpp to main_og.cpp

// edit gen/runner/CMakeList.txt to include our source files from monarch/platform/windows/src,
// maybe find and replace "main.cpp", include all files in src, no need for manifest
// file or yaml file pointing at which files we should use, if it is in src, then it
// should be built
// cmd: cmake.exe -S gen -B build\{flutter_sdk} -G "Visual Studio 16 2019"
// the build directory should be created

// cmd: cmake.exe --build build\{flutter_sdk} --config Debug --target INSTALL --verbose
// NEXT: figure out cmake exit codes or how to detect when it fails
// NEXT: the build/runner/Debug/*.exe files should be created, those files can be copied to the out directory
}

/// Returns source files which should be included in CMakeLists.txt
bool _isSourceFile(FileSystemEntity element) {
  return element is File && p.extension(element.path) == '.cpp';
}
