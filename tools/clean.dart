import 'dart:io';
import 'paths.dart' as paths;

void main() {
  print('''

### clean.dart
''');

  cleanDirectory(paths.out);

  if (Platform.isWindows) {
    cleanDirectory(paths.platform_windows_gen_seed);
    cleanDirectory(paths.platform_windows_gen);
    cleanDirectory(paths.platform_windows_build);
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