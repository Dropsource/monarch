import 'dart:io';

T valueForPlatform<T>({
  required T macos,
  required T windows,
  T? linux,
}) {
  if (Platform.isMacOS) {
    return macos;
  } else if (Platform.isWindows) {
    return windows;
  } else if (Platform.isLinux) {
    if (linux == null) {
      throw ArgumentError.notNull('linux');
    } else {
      return linux;
    }
  } else {
    throw UnsupportedError(
        'The ${Platform.operatingSystem} platform is not supported');
  }
}

T functionForPlatform<T>({
  required T Function() macos,
  required T Function() windows,
  T Function()? linux,
}) {
  if (Platform.isMacOS) {
    return macos();
  } else if (Platform.isWindows) {
    return windows();
  } else if (Platform.isLinux) {
    if (linux == null) {
      throw ArgumentError.notNull('linux');
    } else {
      return linux();
    }
  } else {
    throw UnsupportedError(
        'The ${Platform.operatingSystem} platform is not supported');
  }
}

Future<T> futureForPlatform<T>({
  required Future<T> Function() macos,
  required Future<T> Function() windows,
  Future<T> Function()? linux,
}) {
  if (Platform.isMacOS) {
    return macos();
  } else if (Platform.isWindows) {
    return windows();
  } else if (Platform.isLinux) {
    if (linux == null) {
      throw ArgumentError.notNull('linux');
    } else {
      return linux();
    }
  } else {
    throw UnsupportedError(
        'The ${Platform.operatingSystem} platform is not supported');
  }
}
