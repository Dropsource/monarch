import 'package:monarch_utils/log.dart';
import 'package:monarch_utils/log_config.dart';

final mainLogger = Logger('main');

void main() {
  // print log entries to console
  logToConsole(printLoggerName: true, printTimestamp: true);

  sum(3, 5);
  sum(7, 11);

  final calculation = Calculation(13, 17);
  calculation.multipy();
}

int sum(int a, int b) {
  // log using a logger object
  final logger = Logger('sum');
  logger.fine('adding $a + $b');
  return a + b;
}

// you can also log using a mixin
class Calculation with Log {
  final int a;
  final int b;

  Calculation(this.a, this.b);

  int multipy() {
    log.info('multiplying $a * $b');
    return a * b;
  }
}