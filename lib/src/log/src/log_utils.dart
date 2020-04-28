
import 'dart:io';

import 'logger.dart';

void logEnvironmentInformation(Logger logger) {
  logger.info('Environment information: ' +
    ' numberOfProcessors=${Platform.numberOfProcessors}' +
    ' localeName="${Platform.localeName}"' +
    ' operatingSystem="${Platform.operatingSystem}"' +
    ' operatingSystemVersion="${Platform.operatingSystemVersion}"' +
    ' localHostname="${Platform.localHostname}"' +
    ' resolvedExecutable="${Platform.resolvedExecutable}"' +
    ' dartRuntimeVersion="${Platform.version}"');
}

void logCurrentProcessInformation(Logger logger) {
  logger.info('Current process information: ' + 
  ' pid=$pid' +
  ' currentRss=${ProcessInfo.currentRss / 1e+6}MB' +
  ' maxRss=${ProcessInfo.maxRss / 1e+6}MB');
}