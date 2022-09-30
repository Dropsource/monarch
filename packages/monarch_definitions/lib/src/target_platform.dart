enum MonarchTargetPlatform { iOS, android }

const String _ios = 'ios';
const String _android = 'android';

String targetPlatformToString(MonarchTargetPlatform platform) {
  switch (platform) {
    case MonarchTargetPlatform.iOS:
      return _ios;
    case MonarchTargetPlatform.android:
      return _android;
    default:
      throw 'Unexpected target platform value $platform';
  }
}

MonarchTargetPlatform targetPlatformFromString(String platform) {
  switch (platform) {
    case _ios:
      return MonarchTargetPlatform.iOS;
    case _android:
      return MonarchTargetPlatform.android;
    default:
      throw 'Unexpected target platform string $platform';
  }
}
