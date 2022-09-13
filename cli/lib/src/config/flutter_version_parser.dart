import 'dart:convert';
import 'dart:io';

import 'package:monarch_io_utils/monarch_io_utils.dart';
import 'package:monarch_utils/log.dart';

class FlutterVersionParser with Log {
  final String flutterExecutablePath;

  FlutterVersionParser(this.flutterExecutablePath);

  Future<FlutterSdkId> getFlutterSdkId() async {
    var output = await _getFlutterVersionOutput();
    return FlutterSdkId.parseFlutterVersionOutput(
        output, Platform.operatingSystem);
  }

  Future<String> _getFlutterVersionOutput() async {
    var helper = Platform.isWindows
        ? NonInteractiveProcess(flutterExecutablePath, ['--version'],
            encoding: Utf8Codec())
        : NonInteractiveProcess(flutterExecutablePath, ['--version']);
    await helper.run();

    if (helper.isSuccess) {
      log.info(helper.getOutputMessage());
      return helper.stdout.trim();
    } else {
      log.severe(helper.getOutputMessage());
      throw 'Error while running "flutter --version" command';
    }
  }
}
