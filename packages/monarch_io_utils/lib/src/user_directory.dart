import 'dart:io';
import 'package:path/path.dart' as p;
import 'platform_utils.dart';

String get userDirectoryEnvironmentVariable =>
    valueForPlatform(macos: 'HOME', windows: 'USERPROFILE', linux: 'HOME');

String? get userDirectoryPath =>
    Platform.environment[userDirectoryEnvironmentVariable];

bool isUserDirectoryValid() {
  if (userDirectoryPath == null) {
    return false;
  }
  if (userDirectoryPath!.isEmpty) {
    return false;
  }
  if (!p.isAbsolute(userDirectoryPath!)) {
    return false;
  }
  return true;
}

String get invalidUserDirectoryMessage => '''
User directory is not valid. Make sure the $userDirectoryEnvironmentVariable environment variable is set and its path is absolute.
''';
