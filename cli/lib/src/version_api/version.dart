/// @GOTCHA: This structure should reflect the Version object in the 
/// monarch_version_api code in lib/version/version.dart
class Version extends Object {
  final DateTime timestamp;
  final String versionNumber;
  final String operatingSystem;
  final bool affectsOperatingSystem;
  final String installationBundleUrl;
  final String cliVersionTag;
  final String desktopAppVersionTag;

  String get key => '$operatingSystem/$versionNumber';

  Version(
      {required this.timestamp,
      required this.versionNumber,
      required this.operatingSystem,
      required this.affectsOperatingSystem,
      required this.installationBundleUrl,
      required this.cliVersionTag,
      required this.desktopAppVersionTag});

  static Version fromJson(Map<String, dynamic> json) {
    return Version(
        timestamp: DateTime.parse(json['timestamp']),
        versionNumber: json['version_number'],
        operatingSystem: json['operating_system'],
        affectsOperatingSystem: json['affects_operating_system'],
        installationBundleUrl: json['installation_bundle_url'],
        cliVersionTag: json['cli_version_tag'],
        desktopAppVersionTag: json['desktop_app_version_tag']);
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
