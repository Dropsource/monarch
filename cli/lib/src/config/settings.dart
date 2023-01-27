import '../../settings.dart' as s;

/// Settings for monarch.
///
/// It prefers values from cli/lib/settings.dart, which are set by
/// a contributor or by automation. If those values are not set,
/// it will return fallback values.
class Settings {
  static String deployment = _get(s.kDeployment) ?? 'local';

  static String elasticsearchEndpoint = _get(s.kElasticsearchEndpoint) ??
      'https://417131bb47ca4cdb9cdf008a09b5f711.us-east-1.aws.found.io:9243';

  static String elasticsearchUsername =
      _get(s.kElasticsearchUsername) ?? 'monarch_cli_src';

  static String elasticsearchPassword =
      _get(s.kElasticsearchPassword) ?? 'TFs+fLxWYTvi+o1AppM=';

  static String versionApiUrl = _get(s.kVersionApiUrl) ?? '';

  static String? _get(String setting) =>
      setting.trim().isEmpty ? null : setting;
}
