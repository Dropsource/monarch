enum MonarchTargetPlatform { iOS, android, macos, windows, linux }

const String _ios = 'ios';
const String _android = 'android';
const String _macos = 'macos';
const String _windows = 'windows';
const String _linux = 'linux';

String targetPlatformToString(MonarchTargetPlatform platform) {
  switch (platform) {
    case MonarchTargetPlatform.iOS:
      return _ios;
    case MonarchTargetPlatform.android:
      return _android;
    case MonarchTargetPlatform.macos:
      return _macos;
    case MonarchTargetPlatform.windows:
      return _windows;
    case MonarchTargetPlatform.linux:
      return _linux;
  }
}

MonarchTargetPlatform targetPlatformFromString(String platform) {
  switch (platform) {
    case _ios:
      return MonarchTargetPlatform.iOS;
    case _android:
      return MonarchTargetPlatform.android;
    case _macos:
      return MonarchTargetPlatform.macos;
    case _windows:
      return MonarchTargetPlatform.windows;
    case _linux:
      return MonarchTargetPlatform.linux;
    default:
      throw 'Unexpected target platform string $platform';
  }
}
