
import 'dart:io';

import 'log_level.dart';
import 'logger.dart';

void logEnvironmentInformation(Logger logger, LogLevel logLevel) {
  logger.log(logLevel, 'Environment information: ' +
    ' numberOfProcessors=${Platform.numberOfProcessors}' +
    ' localeName="${Platform.localeName}"' +
    ' operatingSystem="${Platform.operatingSystem}"' +
    ' operatingSystemVersion="${Platform.operatingSystemVersion}"' +
    ' localHostname="${Platform.localHostname}"' +
    ' resolvedExecutable="${Platform.resolvedExecutable}"' +
    ' dartRuntimeVersion="${Platform.version}"');
}

void logCurrentProcessInformation(Logger logger, LogLevel logLevel) {
  logger.log(logLevel, 'Current process information: ' + 
  ' pid=$pid' +
  ' currentRss=${ProcessInfo.currentRss / 1e+6}MB' +
  ' maxRss=${ProcessInfo.maxRss / 1e+6}MB');
}