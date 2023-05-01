import 'dart:io';
import 'paths.dart';

void clean() {
  print('''

### clean.dart
''');

  cleanDirectory(local_out_paths.out);

  if (Platform.isWindows) {
    cleanDirectory(local_repo_paths.platform_windows_gen_seed);
    cleanDirectory(local_repo_paths.platform_windows_gen);
    cleanDirectory(local_repo_paths.platform_windows_build);
  }

  if (Platform.isLinux) {
    cleanDirectory(local_repo_paths.platform_linux_gen_seed);
    cleanDirectory(local_repo_paths.platform_linux_gen);
    cleanDirectory(local_repo_paths.platform_linux_build);
  }
}

/// Deletes and re-creates the directory at the given path.
void cleanDirectory(String path) {
  print('''
Cleaning directory at:
  ${path}
''');
  var dir = Directory(path);
  if (dir.existsSync()) dir.deleteSync(recursive: true);
  dir.createSync(recursive: true);
}