import 'dart:io';

import 'versions.dart';

Future<void> printVersion() async {
  print('Monarch binaries version: $monarchBinariesVersion');
  print('Monarch CLI: $monarchCliVersionTag');
  print('Monarch UI: $monarchUiVersionTag');
  print('Operating system: ${Platform.operatingSystem}');
}
