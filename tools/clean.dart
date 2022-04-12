import 'dart:io';
import 'paths.dart' as paths;

void main() {
  print('''

### clean.dart
''');

  print('''
Cleaning build output directory at:
  ${paths.out}
''');
  var outDir = Directory(paths.out);
  if (outDir.existsSync()) outDir.deleteSync(recursive: true);
  outDir.createSync(recursive: true);
}
