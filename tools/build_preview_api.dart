import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart' as pub;

import 'paths.dart';
import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;

/// Builds Monarch Preview API artifacts with these arguments:
/// - Path to the root of the Monarch repo
/// - Path to the Flutter SDK to use
/// - Path to the monarch_ui/{flutter_id} output directory
void buildPreviewApi(String repo_root, String flutter_sdk, String out_ui_flutter_id) {
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


  var flutterVersion = pub.Version.parse(get_flutter_version(flutter_sdk));
  var flutterVersionWithDart3 = pub.Version(3, 8, 0, pre: '10.1.pre');

  var useGrpc310 = flutterVersion < flutterVersionWithDart3;
  if (useGrpc310) {
    print('Running `git apply grpc_310.patch`\n');
    utils.gitApplyPatch(repo_paths.preview_api, 'grpc_310.patch');
  }

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
    var icudtl_dat_ = icudtl_dat(flutter_sdk, local_utils.read_target_platform());

    if (Platform.isWindows) {
      var result = Process.runSync(
          'copy', [icudtl_dat_, out_ui_flutter_id_preview_api],
          runInShell: true);
      utils.exitIfNeeded(
          result, 'Error copying icudtl.dat to monarch_preview_api directory');
    }
    if (Platform.isLinux) {
      var result =
          Process.runSync('cp', [icudtl_dat_, out_ui_flutter_id_preview_api]);
      utils.exitIfNeeded(
          result, 'Error copying icudtl.dat to monarch_preview_api directory');
    }
  }

  if (useGrpc310) {
    print('Running `git apply -R grpc_310.patch`\n');
    utils.gitRevertPatch(repo_paths.preview_api, 'grpc_310.patch');
  }

  print('Monarch preview_api build finished.');

  print('''
===============================================================================
''');
}

