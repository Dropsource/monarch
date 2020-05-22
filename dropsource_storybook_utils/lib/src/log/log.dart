import 'logger.dart';

mixin Log {
  Logger _log;

  Logger get log {
    return _log ??= Logger(prefix);
  }

  String get prefix => runtimeType.toString();

  void logInfo(Object object) => log.info(object);

  void logWarning(Object object, [dynamic e]) {
    log.warning(object);
    if (e != null) {
      log.warning(object, e);
    }
  }

  void logError(Object object) => log.severe(object);

  void logException(Object object, dynamic e, StackTrace s) =>
      log.severe(object, e, s);

  static String kvp(String key, Object value) {
    return '$key=$value';
  }
}
