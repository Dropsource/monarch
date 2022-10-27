import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:monarch_io_utils/monarch_io_utils.dart';

final defaultMonarchBinaries = MonarchBinaries(Platform.resolvedExecutable);

class MonarchBinaries {
  final String monarchExecutablePath;
  MonarchBinaries(this.monarchExecutablePath);

  Directory get binDirectory => File(monarchExecutablePath).parent;

  Directory get monarchDirectory => binDirectory.parent;

  String get monarchAppExecutableName => valueForPlatform(
      macos: p.join('Monarch.app', 'Contents', 'MacOS', 'Monarch'),
      windows: 'monarch_windows_app.exe');

  Directory get cacheDirectory => Directory(p.join(binDirectory.path, 'cache'));
  Directory get internalDirectory =>
      Directory(p.join(binDirectory.path, 'internal'));

  Directory get monarchUiDirectory =>
      Directory(p.join(cacheDirectory.path, 'monarch_ui'));

  Directory uiIdDirectory(FlutterSdkId id) =>
      Directory(p.join(monarchUiDirectory.path, id.toString()));

  File monarchAppExecutableFile(FlutterSdkId id) {
    final appExecutablePath =
        p.join(uiIdDirectory(id).path, monarchAppExecutableName);
    return File(appExecutablePath);
  }

  File icuDataFile(FlutterSdkId id) {
    final path = p.join(uiIdDirectory(id).path, 'icudtl.dat');
    return File(path);
  }

  Directory previewApiDirectory(FlutterSdkId id) =>
      Directory(p.join(uiIdDirectory(id).path, 'monarch_preview_api'));

  Directory controllerDirectory(FlutterSdkId id) =>
      Directory(p.join(uiIdDirectory(id).path, 'monarch_controller'));
}
