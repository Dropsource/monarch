import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:monarch_io_utils/monarch_io_utils.dart';

class ApplicationSupportDirectory {
  static String dataDirectoryRelativePath = valueForPlatform(
      macos: 'Library/Application Support/com.dropsource.monarch/data',
      windows: r'AppData\Local\Monarch\data');

  static String logsDirectoryRelativePath = valueForPlatform(
      macos: 'Library/Application Support/com.dropsource.monarch/logs',
      windows: r'AppData\Local\Monarch\logs');

  static File get userDeviceIdFile => File(p.join(
      userDirectoryPath!, dataDirectoryRelativePath, 'user_device_id.info'));

  static File get emailCapturedFile => File(p.join(
      userDirectoryPath!, dataDirectoryRelativePath, 'email_captured.info'));

  static File get logsInfoFile =>
      File(p.join(userDirectoryPath!, logsDirectoryRelativePath, 'logs.info'));

  static bool get isValid => isUserDirectoryValid();

  static String notValidMessage = invalidUserDirectoryMessage;
}
