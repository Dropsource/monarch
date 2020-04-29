import 'dart:developer';

import 'package:dropsource_storybook_utils/log.dart' as ds_log;

final _logger = ds_log.Logger('ApplicationServer');

void main() async {
  await _initializeLog();

  final serviceInfo = await Service.getInfo();
  _logger.config('APPLICATION SERVER STARTED -- AT: ${serviceInfo.serverUri}');
}

Future<void> _initializeLog() async {
  ds_log.defaultLogLevel = ds_log.LogLevel.ALL;
  ds_log.logToConsole(recordTime: true);
  ds_log.logEnvironmentInformation(_logger);
}