class Version extends Object {
  final DateTime timestamp;
  final String versionNumber;
  final String operatingSystem;
  final bool affectsOperatingSystem;
  final String versionTag;
  final String revision;
  final String installationBundleUrl;
  final String minFlutterVersion;
  final bool isReleased;

  String get key => '$operatingSystem/$versionNumber';

  Version({
    required this.timestamp,
    required this.versionNumber,
    required this.operatingSystem,
    required this.affectsOperatingSystem,
    required this.versionTag,
    required this.revision,
    required this.installationBundleUrl,
    required this.minFlutterVersion,
    required this.isReleased,
  });

  static Version fromJson(Map<String, dynamic> json) {
    return Version(
      timestamp: DateTime.parse(json['timestamp']),
      versionNumber: json['version_number'],
      operatingSystem: json['operating_system'],
      affectsOperatingSystem: json['affects_operating_system'],
      versionTag: json['version_tag'],
      revision: json['revision'],
      installationBundleUrl: json['installation_bundle_url'],
      minFlutterVersion: json['min_flutter_version'],
      isReleased: json['is_released'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is Version) {
      return operatingSystem == other.operatingSystem &&
          versionNumber == other.versionNumber;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => key.hashCode;
}
