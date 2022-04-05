import 'package:test/test.dart';

import 'package:monarch_io_utils/utils.dart';

void main() {
  test('getPrettyCommand', () {
    expect(getPrettyCommand('git', ['status']), 'git status');
    expect(getPrettyCommand('/bin/ls', ['-la']), 'ls -la');
    expect(getPrettyCommand('/bin/cp', ['foo.txt', 'bar.txt']),
        'cp foo.txt bar.txt');
    expect(getPrettyCommand('/path/to/some_exe', ['-a', '--verbose', '/another/path']),
        'some_exe -a --verbose /another/path');
  });
}
