import 'dart:io';
import 'package:path/path.dart' as p;

import 'paths.dart';
import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;

/// Builds Monarch Controller artifacts with these arguments:
/// - Path to the root of the Monarch repo
/// - Path to the Flutter SDK to use
/// - Path to the monarch_ui/{flutter_id} output directory
void buildController(
    String repo_root, String flutter_sdk, String out_ui_flutter_id) {
  var repo_paths = RepoPaths(repo_root);

  print('''
===============================================================================
Building Monarch Controller using these arguments:
- Monarch repository: 
  $repo_root
- Flutter SDK: 
  $flutter_sdk
  Flutter version ${get_flutter_version(flutter_sdk)}, ${get_flutter_channel(flutter_sdk)} channel.
- Output directory:
  $out_ui_flutter_id
''');

  var out_ui_flutter_id_controller =
      p.join(out_ui_flutter_id, 'monarch_controller');
  var out_controller_dir = Directory(out_ui_flutter_id_controller);
  if (out_controller_dir.existsSync())
    out_controller_dir.deleteSync(recursive: true);
  out_controller_dir.createSync(recursive: true);

  {
    print('''
Running `flutter pub get` in:
  ${repo_paths.controller}
''');
    var result = Process.runSync(flutter_exe(flutter_sdk), ['pub', 'get'],
        workingDirectory: repo_paths.controller,
        runInShell: Platform.isWindows);
    utils.exitIfNeeded(result, 'Error running `flutter pub get`');
  }

  {
    print('''
Building monarch controller flutter bundle. Will output to:
  $out_ui_flutter_id_controller
''');

    var result = Process.runSync(
        flutter_exe(flutter_sdk),
        [
          'build',
          'bundle',
          '-t',
          'lib/main.dart',
          '--debug',
          '--target-platform',
          local_utils.read_target_platform(),
          '--asset-dir',
          p.join(out_ui_flutter_id_controller, 'flutter_assets'),
          '--verbose'
        ],
        workingDirectory: repo_paths.controller,
        runInShell: Platform.isWindows);

    utils.exitIfNeeded(
        result, 'Error building monarch controller flutter bundle');
  }

  {
    var icudtl_dat_ =
        icudtl_dat(flutter_sdk, local_utils.read_target_platform());

    if (Platform.isWindows) {
      var result = Process.runSync(
          'copy', [icudtl_dat_, out_ui_flutter_id_controller],
          runInShell: true);
      utils.exitIfNeeded(
          result, 'Error copying icudtl.dat to monarch_controller directory');
    }
    if (Platform.isLinux) {
      var result =
          Process.runSync('cp', [icudtl_dat_, out_ui_flutter_id_controller]);
      utils.exitIfNeeded(
          result, 'Error copying icudtl.dat to monarch_controller directory');
    }
  }

  print('Monarch controller build finished.');

  print('''
===============================================================================
''');
}
