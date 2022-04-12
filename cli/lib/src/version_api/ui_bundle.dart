class UiBundle {
  final DateTime timestamp;
  final String versionNumber;
  final String operatingSystem;
  final String flutterVersion;
  final String flutterChannel;
  final String uiBundleUrl;

  String get key =>
      '$operatingSystem/$versionNumber/flutter/$flutterVersion/$flutterChannel';

  UiBundle(
      {required this.timestamp,
      required this.versionNumber,
      required this.operatingSystem,
      required this.flutterVersion,
      required this.flutterChannel,
      required this.uiBundleUrl});

  static UiBundle fromJson(Map<String, dynamic> json) {
    return UiBundle(
        timestamp: DateTime.parse(json['timestamp']),
        versionNumber: json['version_number'],
        operatingSystem: json['operating_system'],
        flutterVersion: json['flutter_version'],
        flutterChannel: json['flutter_channel'],
        uiBundleUrl: json['ui_bundle_url']);
  }
}
