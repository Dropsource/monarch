import 'package:monarch_utils/timers.dart';
import 'utils_local.dart' as local_utils;
import 'run_tests_args.dart' as run_tests_args;

import 'paths.dart';

void main() async {
  var stopwatch = Stopwatch()..start();
  print('''

### run_tests.dart

Monarch binaries:
  ${local_out_paths.out}

Flutter SDKs:''');
  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    print('- $flutter_sdk');
  }

  print('');

  var resultsMap = <String, List<run_tests_args.TestResult>>{};

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = await run_tests_args.runTests(
        flutter_exe(flutter_sdk), local_out_paths.out_bin_monarch_exe);
    resultsMap[flutter_sdk] = results;
  }

  print('''


### run_tests.dart results

Results per Flutter SDK:''');
  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    var results = resultsMap[flutter_sdk]!;
    if (results.every((result) => result.passed)) {
      print('- PASSED: $flutter_sdk');
    }
    else {
      print('- FAILED: $flutter_sdk');
      for (var result in results.where((result) => !result.passed)) {
        print ('  - $result');
      }
    }
  }


  print('''

Tested with monarch binaries:
  ${local_out_paths.out}

All tests took ${stopwatch..stop()}.''');
}
