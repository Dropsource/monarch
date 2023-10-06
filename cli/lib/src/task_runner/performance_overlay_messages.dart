const unexpectedVisualDebugFlag = 'Unexpected visual debug flag name, got performanceOverlay';

final monarchPackageUpgrade = '''

${'*' * 80}
The monarch package in your pubspec.yaml does not support the new performance overlay flag.
Please upgrade to monarch ^3.6.0.
If you are on monarch 3.1.0, then please upgrade to monarch ^3.1.1.
${'*' * 80}
''';