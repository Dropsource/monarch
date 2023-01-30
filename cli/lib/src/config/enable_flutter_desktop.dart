import 'dart:io';
import 'package:path/path.dart' as p;
import 'dart:convert' as convert;

import 'package:monarch_utils/log.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

import 'project_config.dart';

class EnableFlutterDesktop with Log {
  final ProjectConfig config;

  EnableFlutterDesktop(this.config);

  static String get flutterSettingsPath => functionForPlatform(
      macos: () => p.join(userDirectoryPath!, '.flutter_settings'),
      windows: () =>
          p.join(userDirectoryPath!, 'AppData', 'Roaming', '.flutter_settings'),
      linux: () =>
          p.join(userDirectoryPath!, '.config', 'flutter', 'settings'));

  static String get enableDesktopKey => valueForPlatform(
      macos: 'enable-macos-desktop',
      windows: 'enable-windows-desktop',
      linux: 'enable-linux-desktop');

  Future<bool> isEnabled() async {
    if (isUserDirectoryValid()) {
      final file = File(flutterSettingsPath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final Map<String, dynamic> map = convert.jsonDecode(contents);
        if (map.containsKey(enableDesktopKey)) {
          return map[enableDesktopKey];
        } else {
          return false;
        }
      } else {
        log.warning(
            '.flutter_settings file not found,  assuming flutter desktop is disabled');
        return false;
      }
    } else {
      log.warning(invalidUserDirectoryMessage);
      log.warning(
          'User directory is not valid, assuming flutter desktop is disabled');
      return false;
    }
  }

  Future<void> enable() async {
    final helper = NonInteractiveProcess(
        config.flutterExecutablePath, ['config', '--$enableDesktopKey'],
        workingDirectory: config.projectDirectory.path);
    await helper.run();

    if (helper.isSuccess) {
      log.info('"${helper.prettyCmd}" run successfully');
    } else {
      log.severe(helper.getOutputMessage());
    }
  }
}
