// Tracks hot reload crash documented here:
// - https://github.com/flutter/flutter/issues/120841
// - https://github.com/Dropsource/monarch/issues/72

import '../version_api/notification.dart';

bool hadHotReloadGrpcError = false;
bool hadUnableToUseClassDartError = false;

Notification workaroundNotification =
    Notification(id: 'reload-crash-workaround', message: '''
You have hit a known Flutter issue. The issue is documented here:
  https://github.com/flutter/flutter/issues/120841

The workaround is to run monarch with the hot-restart option:
  monarch run --reload hot-restart
''');

Notification workaroundMaybeNotification =
    Notification(id: 'reload-crash-workaround-maybe', message: '''
You may have hit a known Flutter issue. The issue is documented here:
  https://github.com/flutter/flutter/issues/120841

If you believe you hit the same issue, the workaround is to run monarch 
with the hot-restart option:
  monarch run --reload hot-restart
''');
