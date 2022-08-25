import 'package:path/path.dart' as p;

import 'paths.dart';
import 'utils.dart' as utils;
import 'utils_local.dart' as local_utils;
import 'build_controller_args.dart' as build_controller_args;

/// Builds Monarch Controller artifacts for each Flutter SDK
/// declared in local_settings.yaml.
void main() {
  print('''

### build_controller.dart
''');

  utils.createDirectoryIfNeeded(local_out_paths.out_ui);

  for (final flutter_sdk in local_utils.read_flutter_sdks()) {
    var out_ui_flutter_id_ =
        out_ui_flutter_id(local_out_paths.out_ui, flutter_sdk);
    utils.createDirectoryIfNeeded(out_ui_flutter_id_);

    build_controller_args
        .main([local_repo_paths.root, flutter_sdk, out_ui_flutter_id_]);
  }

  var version =
      utils.readPubspecVersion(p.join(local_repo_paths.controller, 'pubspec.yaml'));
  version = local_utils.getVersionSuffix(version);

  local_utils.writeInternalFile('controller_version.txt', version);

  print('Monarch controller build finished. Version $version');
}
