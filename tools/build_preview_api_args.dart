import 'dart:io';
import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:path/path.dart' as p;

import 'paths.dart';
import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;

/// Builds Monarch Preview API artifacts with these arguments:
/// - Path to the root of the Monarch repo
/// - Path to the Flutter SDK to use
/// - Path to the monarch_ui/{flutter_id} output directory
///
/// This script is used by local builds and by the monarch automation.
void main(List<String> arguments) {
  var repo_root = arguments[0];
  var flutter_sdk = arguments[1];
  var out_ui_flutter_id = arguments[2];

  var repo_paths = RepoPaths(repo_root);

  print('''
===============================================================================
Building Monarch Preview API using these arguments:
- Monarch repository: 
  $repo_root
- Flutter SDK: 
  $flutter_sdk
  Flutter version ${get_flutter_version(flutter_sdk)}, ${get_flutter_channel(flutter_sdk)} channel.
- Output directory:
  $out_ui_flutter_id
''');

  var out_ui_flutter_id_preview_api =
      p.join(out_ui_flutter_id, 'monarch_preview_api');
  var out_preview_api_dir = Directory(out_ui_flutter_id_preview_api);
  if (out_preview_api_dir.existsSync())
    out_preview_api_dir.deleteSync(recursive: true);
  out_preview_api_dir.createSync(recursive: true);

  {
    print('''
Running `flutter pub get` in:
  ${repo_paths.preview_api}
''');
    var result = Process.runSync(flutter_exe(flutter_sdk), ['pub', 'get'],
        workingDirectory: repo_paths.preview_api,
        runInShell: Platform.isWindows);
    utils.exitIfNeeded(result, 'Error running `flutter pub get`');
  }

  {
    print('''
Building monarch preview_api flutter bundle. Will output to:
  $out_ui_flutter_id_preview_api
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
          p.join(out_ui_flutter_id_preview_api, 'flutter_assets'),
          '--verbose'
        ],
        workingDirectory: repo_paths.preview_api,
        runInShell: Platform.isWindows);

    utils.exitIfNeeded(
        result, 'Error building monarch preview_api flutter bundle');
  }

  {
    var icudtl_dat = p.join(flutter_sdk, 'bin', 'cache', 'artifacts', 'engine',
        local_utils.read_target_platform(), 'icudtl.dat');

    if (Platform.isWindows) {
      var result = Process.runSync(
          'copy', [icudtl_dat, out_ui_flutter_id_preview_api],
          runInShell: true);
      utils.exitIfNeeded(
          result, 'Error copying icudtl.dat to monarch_preview_api directory');
    }
    if (Platform.isLinux) {
      var result =
          Process.runSync('cp', [icudtl_dat, out_ui_flutter_id_preview_api]);
      utils.exitIfNeeded(
          result, 'Error copying icudtl.dat to monarch_preview_api directory');
    }
  }

  print('''
===============================================================================
''');
}
