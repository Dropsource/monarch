import 'version.dart';

class UpgradeInfo {
  final bool shouldUpgrade;
  final Version? latestVersion;

  UpgradeInfo({required this.shouldUpgrade, this.latestVersion});

  static UpgradeInfo fromJson(Map<String, dynamic> json) {
    return UpgradeInfo(
        shouldUpgrade: json['should_upgrade'],
        latestVersion: json['latest_version'] != null
            ? Version.fromJson(json['latest_version'])
            : null);
  }
}
