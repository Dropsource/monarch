import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:pub_semver/pub_semver.dart' as pub;

import 'paths.dart';
import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;

/// Builds Monarch Platform artifacts with these arguments:
/// - Path to the root of the Monarch repo
/// - Path to the Flutter SDK to use
/// - Path to the monarch_ui/{flutter_id} output directory
///
/// This script is used by local builds and by the monarch automation.
void buildPlatform(
    String repo_root, String flutter_sdk, String out_ui_flutter_id) {
  var repo_paths = RepoPaths(repo_root);

  print('''
===============================================================================
Building Monarch Platform using these arguments:
- Monarch repository: 
  $repo_root
- Flutter SDK: 
  $flutter_sdk
  Flutter version ${get_flutter_version(flutter_sdk)}, ${get_flutter_channel(flutter_sdk)} channel.
- Output directory:
  $out_ui_flutter_id
''');

  {
    print('Running `flutter precache`...');
    var result = Process.runSync(flutter_exe(flutter_sdk), ['precache'],
        runInShell: Platform.isWindows);
    utils.exitIfNeeded(result, 'Error running `flutter precache`');
  }

  if (Platform.isMacOS) {
    buildMacOs(repo_paths, flutter_sdk, out_ui_flutter_id);
  }

  if (Platform.isWindows) {
    buildWindows(repo_paths, flutter_sdk, out_ui_flutter_id);
  }

  if (Platform.isLinux) {
    buildLinux(repo_paths, flutter_sdk, out_ui_flutter_id);
  }

  print('');
  print('Monarch ${os} platform build finished.');

  print('''
===============================================================================
''');
}

void buildMacOs(
    RepoPaths repo_paths, String flutter_sdk, String out_ui_flutter_id) {
  const monarch_macos = 'monarch_macos';
  var flutterVersion = pub.Version.parse(get_flutter_version(flutter_sdk));

  var ephemeral_dir = Directory(repo_paths.platform_macos_ephemeral);
  if (ephemeral_dir.existsSync()) ephemeral_dir.deleteSync(recursive: true);
  ephemeral_dir.createSync(recursive: true);

  print('Copying darwin flutter framework bundle to ephemeral directory...');

  var flutterVersionWithXcFrameworkChange = pub.Version(3, 20, 0);
  var useXcFramework = flutterVersion >= flutterVersionWithXcFrameworkChange;

  var result = Process.runSync('cp', [
    '-R',
    useXcFramework
        ? darwin_flutter_xcframework(flutter_sdk)
        : darwin_flutter_framework(flutter_sdk),
    repo_paths.platform_macos_ephemeral
  ]);
  utils.exitIfNeeded(result, 'Error copying darwin flutter framework bundle');

  var monarch_macos_app_dir =
      Directory(out_ui_flutter_id_monarch_macos_app(out_ui_flutter_id));
  if (monarch_macos_app_dir.existsSync())
    monarch_macos_app_dir.deleteSync(recursive: true);

  print('''
Building $monarch_macos with xcodebuild. Will output to:
  ${out_ui_flutter_id_monarch_macos_app(out_ui_flutter_id)}''');

  /// The Flutter macOS API changed between versions. Here we use preprocessor
  /// directives to compile our code with different Flutter versions.
  ///
  /// In flutter version 3.11.0-17.0.pre, the flutter team introduced
  /// FlutterAppDelegate lifecycle methods which is when the embedder error may
  /// have started. Also, we have to use the lifecycle methods to avoid the embedder error.
  /// However, those methods are only available after the flutter version above.
  /// - https://github.com/flutter/engine/pull/42418
  /// - https://github.com/Dropsource/monarch/pull/127
  ///
  /// In flutter version 3.14.0-0.1.pre, the flutter team fixed an issue
  /// in the flutter engine. As a result, we don't have to use FlutterAppDelegate
  /// anymore. Monarch macOS works better if we don't use FlutterAppDelegate.
  /// - https://github.com/flutter/flutter/issues/124829
  /// - https://github.com/flutter/engine/pull/43425
  /// - https://github.com/Dropsource/monarch/pull/124
  var flutterVersionWithFlutterAppDelegateChange =
      pub.Version(3, 14, 0, pre: '0.1.pre');
  var flutterVersionWithApplicationLifecycleMethods =
      pub.Version(3, 11, 0, pre: '17.0.pre');

  var useFlutterAppDelegate =
      flutterVersion < flutterVersionWithFlutterAppDelegateChange;

  var useApplicationLifecycleMethods =
      flutterVersion >= flutterVersionWithApplicationLifecycleMethods;

  result = Process.runSync(
      'xcodebuild',
      [
        '-scheme',
        '$monarch_macos',
        'CONFIGURATION_BUILD_DIR=$out_ui_flutter_id',
        'build',
        if (useFlutterAppDelegate)
          'SWIFT_ACTIVE_COMPILATION_CONDITIONS=USE_FLUTTER_APP_DELEGATE',
        if (useFlutterAppDelegate && useApplicationLifecycleMethods)
          'SWIFT_ACTIVE_COMPILATION_CONDITIONS=USE_FLUTTER_APP_DELEGATE USE_APPLICATION_LIFECYCLE_METHODS'
      ],
      workingDirectory: repo_paths.platform_macos);
  utils.exitIfNeeded(result, 'Error running xcodebuild');

  var swiftmodule = Directory(p.join(out_ui_flutter_id, 'Monarch.swiftmodule'));
  if (swiftmodule.existsSync()) swiftmodule.deleteSync(recursive: true);
}

/// Builds the monarch_windows_app for the given [flutter_sdk].
///
/// For details on how the Monarch Windows build works see:
/// - file: platform/windows/README.md
/// - section: How the Monarch Windows build works
void buildWindows(
    RepoPaths repo_paths, String flutter_sdk, String out_ui_flutter_id) {
  var gen_seed_dir = Directory(
      gen_seed_flutter_id(repo_paths.platform_windows_gen_seed, flutter_sdk));
  if (_isGenSeedDirectoryOk(gen_seed_dir, 'windows')) {
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
        flutter_exe(flutter_sdk),
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
        flutter_exe(flutter_sdk), ['build', 'windows', '--debug'],
        workingDirectory: gen_seed_dir.path, runInShell: true);
    utils.exitIfNeeded(result, 'Error running `flutter build`');

    // After `flutter build`, the ephemeral directory in
    // gen_seed/{flutter_id}/windows/flutter/ephemeral
    // should be there with the flutter windows dlls.
  }

  {
    print('Cleaning gen directory...');
    var gen_dir = Directory(repo_paths.platform_windows_gen);
    if (gen_dir.existsSync()) gen_dir.deleteSync(recursive: true);
    gen_dir.createSync(recursive: true);
  }

  {
    print('Copying gen_seed/{flutter_id}/windows/* to gen directory...');
    var result = Process.runSync(
        'robocopy',
        [
          p.join(
              gen_seed_flutter_id(
                  repo_paths.platform_windows_gen_seed, flutter_sdk),
              'windows'),
          repo_paths.platform_windows_gen,
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
      var main_cpp =
          p.join(repo_paths.platform_windows_gen, 'runner', 'main.cpp');
      var main_og_file = File(main_cpp);
      main_og_file
          .renameSync(p.join(main_og_file.parent.path, 'main_original.cpp'));
    }

    {
      /// Write version number and app icon in gen/runner/Runner.rc
      var runner_rc =
          p.join(repo_paths.platform_windows_gen, 'runner', 'Runner.rc');
      var runner_rc_file = File(runner_rc);
      var contents = runner_rc_file.readAsStringSync();
      runner_rc_file
          .renameSync(p.join(runner_rc_file.parent.path, 'Runner_original.rc'));

      var buildSettings =
          File(p.join(repo_paths.platform_windows, 'build_settings.yaml'))
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
          p.join(repo_paths.platform_windows_gen, 'runner', 'flutter_window.h');
      var flutter_window_h_file = File(flutter_window_h);
      var contents = flutter_window_h_file.readAsStringSync();
      contents = _assertAndReplace(contents, 'private:', 'protected:');
      flutter_window_h_file.writeAsStringSync(contents);
    }
  }

  var cmakelists_txt =
      p.join(repo_paths.platform_windows_gen, 'runner', 'CMakeLists.txt');

  {
    print('Including src files in CMakeLists.txt...');
    var cmakelists_og_file = File(cmakelists_txt);
    var cmakelistsContents = cmakelists_og_file.readAsStringSync();
    cmakelists_og_file.renameSync(
        p.join(cmakelists_og_file.parent.path, 'CMakeLists_original.txt'));

    var src_dir = Directory(repo_paths.platform_windows_src);
    var srcFiles = src_dir.listSync(recursive: true, followLinks: false);
    srcFiles = srcFiles.where(_isSourceFile).toList();
    var buffer = StringBuffer();
    for (var srcFile in srcFiles) {
      var _path = p.relative(srcFile.path,
          from: p.join(repo_paths.platform_windows_gen, 'runner'));
      _path = _path.replaceAll(r'\', r'/');
      buffer.writeln('  "$_path"');
    }

    // Replace "main.cpp" for the list of files in the src directory
    cmakelistsContents = _assertAndReplace(
        cmakelistsContents, '"main.cpp"', buffer.toString().trim());

    File(cmakelists_txt).writeAsStringSync(cmakelistsContents);
  }

  {
    print('Append preprocessor directives to CMakeLists.txt...');

    /// We can use preprocessor directives so the Monarch C++ code can compile with
    /// different Flutter versions. Sometimes the Flutter Windows APIs
    /// change between versions.
    ///
    /// In flutter version 3.4.0-34.1.pre, the flutter team changed the signature of a
    /// function we use. `Win32Window::CreateAndShow` changed to `Win32Window::Create`.
    /// See PR: https://github.com/flutter/flutter/pull/109816/files
    /// See file: packages/flutter_tools/templates/app_shared/windows.tmpl/runner/win32_window.cpp
    ///
    /// Here we set a preprocessor directive to flag the change so the Monarch source code
    /// can adapt to the change.
    var flutterVersion = pub.Version.parse(get_flutter_version(flutter_sdk));
    var flutterVersionWithCreateWindowApiChange =
        pub.Version(3, 4, 0, pre: '34.1.pre');
    var buffer = StringBuffer();

    if (flutterVersion >= flutterVersionWithCreateWindowApiChange) {
      buffer.writeln();
      buffer.writeln('''
# Monarch preprocessor definitions
target_compile_definitions(\${BINARY_NAME} PRIVATE "MONARCH_WINDOW_API_CREATE")
''');
    }

    File(cmakelists_txt)
        .writeAsStringSync(buffer.toString(), mode: FileMode.writeOnlyAppend);
  }

  {
    print('Generating Visual Studio build system using CMake...');
    var result = Process.runSync(
        'cmake.exe',
        [
          '-S',
          'gen',
          '-B',
          p.join('build', flutter_id(flutter_sdk)),
          '-G',
          'Visual Studio 17 2022'
        ],
        workingDirectory: repo_paths.platform_windows,
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
          p.join('build', flutter_id(flutter_sdk)),
          '--config',
          'Debug',
          '--target',
          'INSTALL',
          '--verbose'
        ],
        workingDirectory: repo_paths.platform_windows,
        runInShell: true);

    utils.exitIfNeededCMake(result, 'CMake error building project');

    // The build/{flutter_id}/runner/Debug/* files should be created,
    // those files can be copied to the out directory
  }

  {
    print('Copying executable files to out directory...');
    var debug = p.join(repo_paths.platform_windows_build,
        flutter_id(flutter_sdk), 'runner', 'Debug');

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

    result = Process.runSync(
        'copy', [windows_flutter_windows_pdb(flutter_sdk), out_ui_flutter_id],
        runInShell: true);
    utils.exitIfNeeded(
        result, 'Error copying flutter_windows.dll.pdb to out directory');
  }
}

/// Builds the monarch_linux_app for the given [flutter_sdk].
///
/// The Monarch Linux builds is similar to the Monarch Windows build.
void buildLinux(
    RepoPaths repo_paths, String flutter_sdk, String out_ui_flutter_id) {
  var gen_seed_dir = Directory(
      gen_seed_flutter_id(repo_paths.platform_linux_gen_seed, flutter_sdk));
  if (_isGenSeedDirectoryOk(gen_seed_dir, 'linux')) {
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
        flutter_exe(flutter_sdk),
        [
          'create',
          '.',
          '--project-name',
          'monarch_linux_app',
          '--platforms',
          'linux',
          '--template',
          'app',
          '--org',
          'com.dropsource'
        ],
        workingDirectory: gen_seed_dir.path);
    utils.exitIfNeeded(result, 'Error running `flutter create`');

    print('Running `flutter build` in gen_seed...');
    result = Process.runSync(
        flutter_exe(flutter_sdk), ['build', 'linux', '--debug'],
        workingDirectory: gen_seed_dir.path);
    utils.exitIfNeeded(result, 'Error running `flutter build`');

    // After `flutter build`, the ephemeral directory in
    // gen_seed/{flutter_id}/linux/flutter/ephemeral
    // should be there with the flutter linux libraries.
  }

  {
    print('Cleaning gen directory...');
    var gen_dir = Directory(repo_paths.platform_linux_gen);
    if (gen_dir.existsSync()) gen_dir.deleteSync(recursive: true);
    gen_dir.createSync(recursive: true);
  }

  {
    print('Copying gen_seed/{flutter_id}/linux/* to gen directory...');
    var gen_seed_flutter_id_ =
        gen_seed_flutter_id(repo_paths.platform_linux_gen_seed, flutter_sdk);
    var result = Process.runSync('cp', [
      '-a',
      '$gen_seed_flutter_id_/linux/.',
      repo_paths.platform_linux_gen,
    ]);

    utils.exitIfNeeded(result, 'Error copying gen_seed to gen directory',
        successExitCodes: [0, 1]);
  }

  {
    print('Editing files in gen directory...');

    void renameToBak(String path) {
      var og_file = File(path);
      og_file.renameSync(og_file.path + '.bak');
    }

    {
      // Rename gen/*.cc to *.cc.bak
      renameToBak(p.join(repo_paths.platform_linux_gen, 'runner', 'main.cc'));
      renameToBak(p.join(repo_paths.platform_linux_gen, 'runner', 'my_application.cc'));
      renameToBak(p.join(repo_paths.platform_linux_gen, 'runner', 'my_application.h'));
    }
  }

  var cmakelists_txt = p.join(repo_paths.platform_linux_gen, 'runner', 'CMakeLists.txt');

  {
    print('Including src files in CMakeLists.txt...');
    var cmakelists_og_file = File(cmakelists_txt);
    var cmakelistsContents = cmakelists_og_file.readAsStringSync();
    cmakelists_og_file.renameSync(cmakelists_og_file.path + '.bak');

    var src_dir = Directory(repo_paths.platform_linux_src);
    var srcFiles = src_dir.listSync(recursive: true, followLinks: false);
    srcFiles = srcFiles.where(_isSourceFile).toList();
    var buffer = StringBuffer();
    for (var srcFile in srcFiles) {
      var _path = p.relative(srcFile.path, from: p.join(repo_paths.platform_linux_gen, 'runner'));
      buffer.writeln('  "$_path"');
    }

    // Replace body of add_executable with our source files
    var pattern = RegExp(r'(?<=add_executable\(\${BINARY_NAME}\n)(.*?)(?=\n\))',
        dotAll: true);
    if (pattern.hasMatch(cmakelistsContents)) {
      var match = pattern.firstMatch(cmakelistsContents)!;
      cmakelistsContents = cmakelistsContents.replaceRange(
          match.start, match.end, buffer.toString().trimRight());
      File(cmakelists_txt).writeAsStringSync(cmakelistsContents);
    } else {
      print('Could not find add_executable in CMakeLists.txt');
      exit(1);
    }
  }

  /// cmake and ninja commands adapted from running `flutter build linux --debug --verbose`
  /// on a flutter sample project

  {
    print('Generating Ninja build system using CMake...');
    var result = Process.runSync(
        'cmake',
        [
          '-S',
          'gen',
          '-B',
          p.join('build', flutter_id(flutter_sdk)),
          '-G',
          'Ninja',
          '-DCMAKE_BUILD_TYPE=Debug',
          '-DFLUTTER_TARGET_PLATFORM=${local_utils.read_target_platform()}'
        ],
        workingDirectory: repo_paths.platform_linux);

    utils.exitIfNeededCMake(
        result, 'CMake error generating Ninja build system');

    // The build/{flutter_id} directory should now be set up.
  }

  {
    print('Building project using Ninja...');
    var result = Process.runSync(
        'ninja', ['-C', p.join('build', flutter_id(flutter_sdk)), 'install'],
        workingDirectory: repo_paths.platform_linux);

    utils.exitIfNeeded(result, 'Ninja error building project');

    // The build/{flutter_id}/bundle/* files should be created,
    // those files can be copied to the out directory
  }

  {
    print('Copying executable files to out directory...');
    var bundle = p.join(
        repo_paths.platform_linux_build, flutter_id(flutter_sdk), 'bundle');

    var result =
        Process.runSync('cp', ['-r', p.join(bundle, 'lib'), out_ui_flutter_id]);
    utils.exitIfNeeded(result, 'Error copying bundle/lib to out directory');

    result = Process.runSync(
        'cp', [p.join(bundle, 'monarch_linux_app'), out_ui_flutter_id]);
    utils.exitIfNeeded(
        result, 'Error copying monarch_linux_app to out directory');

    result = Process.runSync(
        'cp', [p.join(bundle, 'data', 'icudtl.dat'), out_ui_flutter_id]);
    utils.exitIfNeeded(result, 'Error copying icudtl.dat to out directory');
  }
}

bool _isGenSeedDirectoryOk(Directory gen_seed_dir, String platform) {
  if (!gen_seed_dir.existsSync()) {
    return false;
  }

  var platform_dir = Directory(p.join(gen_seed_dir.path, platform));
  if (!platform_dir.existsSync()) {
    return false;
  }

  var build_dir = Directory(p.join(gen_seed_dir.path, 'build'));
  if (!build_dir.existsSync()) {
    return false;
  }

  if (platform_dir.listSync().isEmpty) {
    return false;
  }

  if (build_dir.listSync().isEmpty) {
    return false;
  }

  return true;
}

/// Returns source files which should be included in CMakeLists.txt
bool _isSourceFile(FileSystemEntity element) {
  return element is File &&
      (p.extension(element.path) == '.cpp' ||
          p.extension(element.path) == '.cc');
}

String _assertAndReplace(String contents, String from, String to) {
  var matches = from.allMatches(contents);
  if (matches.length != 1) {
    print('Expected to find 1 match for $from - got ${matches.length}');
    exit(1);
  }
  return contents.replaceFirst(from, to);
}
