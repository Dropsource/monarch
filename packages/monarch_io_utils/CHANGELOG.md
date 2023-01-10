## 1.3.0 - 2023-01-10
- Linux support in platform_utils function, backwards compatible.

## 1.2.0 - 2022-09-13
- Publishing to pub.dev

## 1.1.0 - 2022-04-12
- Migrate from pedantic to lints

## 1.0.1 - 2022-04-05
- Explicitly add package:meta dependency

## 1.0.0 - 2021-11-04
- Add string utility function `hardWrap`
- This package is stable, bumping to version 1.0.0

## 0.2.7 - 2021-05-24
- Parse "unknown" as a flutter channel due to other tools mangling the flutter channel: https://github.com/leoafarias/fvm/issues/291
- FlutterChannels constants

## 0.2.5 - 2021-05-21
- Add linux option to valueForPlatform and userDirectory

## 0.2.4 - 2021-05-07
- Add runSync to NonInteractiveProcess
- Pass operatingSystem to FlutterSdkId functions, do not take it from the 
  running Platform object since a FlutterSdkId object could represent a flutter version
  from another platform.
- Parse FlutterSdkId from `flutter --version` using multiLine matching

## 0.2.1 - 2021-05-05
- Rename ProcessRunHelper to NonInteractiveProcess
- Add encoding to NonInteractiveProcess
- Make NonInteractiveProcess.run async

## 0.1.12 - 2021-05-03
- Parse FlutterSdkId from `flutter --version`
- Add duration to LongRunningClic

## 0.1.10 - 2021-04-30
- Export src/flutter_sdk_id.dart

## 0.1.9 - 2021-04-30
- Add FlutterSdkId class and tests

## 0.1.8 - 2021-04-29
- Add T to futureForPlatform

## 0.1.7 - 2021-04-21
- Tweak

## 0.1.6 - 2021-04-21
- Make LongRunningCli's terminate and willTerminate return Futures so
  implementations can do async termination before completion.

## 0.1.5 - 2021-04-21
- Export src/long_running_cli.dart

## 0.1.4 - 2021-04-21
- LongRunningCli
- Change ProcessRunHelper.getOutputMessage to improve log formatting

## 0.1.3 - 2021-04-16
- Change ProcessRunHelper.getOutputMessage to improve log formatting

## 0.1.2 - 2021-04-15
- Add user directory utils

## 0.1.1
- Export src/process_run_helper.dart

## 0.1.0
- Add Future utils
- Add Platform utils
- Add ProcessRunHelper
- Add Process utils
- Tests for some