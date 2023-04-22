import 'package:monarch_utils/timers.dart';
import 'utils_local.dart' as local_utils;
import 'run_tests_args.dart' as run_tests_args;

import 'paths.dart';

void main() async {
  var stopwatch = Stopwatch()..start();
  print('''

### run_tests.dart''');

  for (var flutter_sdk in local_utils.read_flutter_sdks()) {
    await run_tests_args.main([
      flutter_exe(flutter_sdk),
      local_out_paths.out_bin_monarch_exe
    ]);
  }

  print('run_tests.dart took ${stopwatch..stop()}.');
}
