/// Tracks hot reload crash documented here:
/// - https://github.com/flutter/flutter/issues/120841
/// - https://github.com/Dropsource/monarch/issues/72

bool hadHotReloadGrpcError = false;
bool hadUnableToUseClassDartError = false;

String knownIssue = '''

*******************************************************************************

You have hit a known Flutter issue. The issue is documented here:
  https://github.com/flutter/flutter/issues/120841

The workaround is to run monarch with the hot-restart option:
  monarch run --reload hot-restart

*******************************************************************************
''';

String maybeKnownIssue = '''

*******************************************************************************

You may have hit a known Flutter issue. The issue is documented here:
  https://github.com/flutter/flutter/issues/120841

If you believe you hit the same issue, the workaround is to run monarch 
with the hot-restart option:
  monarch run --reload hot-restart

*******************************************************************************
''';
