import 'package:http/http.dart' as http;
import 'package:monarch_http/utils.dart';
import 'dart:convert' as convert;

import 'package:monarch_utils/log.dart';

import '../../settings.dart' as settings;
import 'package:monarch_http/utils.dart' as request_utils;
import 'version.dart';
import 'upgrade_info.dart';
import 'ui_bundle.dart';
import 'notification.dart';

abstract class AbstractVersionApi {
  Future<Version> getLatestVersion(String operatingSystem);
  Future<UpgradeInfo> getUpgradeInfo(
      String operatingSystem, String versionNumber);
  Future<UiBundle> getUiBundle(
      {required String operatingSystem,
      required String versionNumber,
      required String flutterVersion,
      required String flutterChannel});
  Future<List<Notification>> getNotifications(
      Map<String, dynamic> contextInfoJson);
  Future<Version> getVersionForUpgrade(Map<String, dynamic> contextInfoJson);
}

class VersionApi with Log implements AbstractVersionApi {
  final String readUserId;
  final BasicAuth _credentials;

  VersionApi({required this.readUserId})
      : _credentials = BasicAuth(readUserId, '');

  @override
  Future<Version> getLatestVersion(String operatingSystem) async {
    var url = '${settings.VERSION_API_URL}/version/$operatingSystem/latest';
    var response = await _httpGet(url);
    return _processResponse(response, Version.fromJson, 'GET $url');
  }

  @override
  Future<UpgradeInfo> getUpgradeInfo(
      String operatingSystem, String versionNumber) async {
    var url =
        '${settings.VERSION_API_URL}/upgrade_info/$operatingSystem/$versionNumber';
    var response = await _httpGet(url);
    return _processResponse(response, UpgradeInfo.fromJson, 'GET $url');
  }

  @override
  Future<UiBundle> getUiBundle(
      {required String operatingSystem,
      required String versionNumber,
      required String flutterVersion,
      required String flutterChannel}) async {
    var url =
        '${settings.VERSION_API_URL}/ui_bundle/$operatingSystem/$versionNumber/flutter/$flutterVersion/$flutterChannel';
    var response = await _httpGet(url);
    return _processResponse(response, UiBundle.fromJson, 'GET $url');
  }

  @override
  Future<List<Notification>> getNotifications(
      Map<String, dynamic> contextInfoJson) async {
    var url = '${settings.VERSION_API_URL}/notifications_query';
    var response = await _httpPost(url, contextInfoJson);
    return _processResponse(response, (Map<String, dynamic> json) {
      var notifications = json['notifications'] as List;
      return notifications.map((n) => Notification.fromJson(n)).toList();
    }, 'POST $url');
  }

  @override
  Future<Version> getVersionForUpgrade(
      Map<String, dynamic> contextInfoJson) async {
    var url = '${settings.VERSION_API_URL}/version/upgrade';
    var response = await _httpPost(url, contextInfoJson);
    return _processResponse(response, Version.fromJson, 'POST $url');
  }

  Future<http.Response> _httpGet(String url) async {
    try {
      var response =
          await http.get(Uri.parse(url), headers: _authorizationHeader);
      return response;
    } catch (e, s) {
      log.warning('Error sending HTTP GET request to $url', e, s);
      throw HttpRequestException();
    }
  }

  Future<http.Response> _httpPost(String url, Object body) async {
    try {
      var response = await http.post(Uri.parse(url),
          headers: _authorizationHeader, body: convert.jsonEncode(body));
      return response;
    } catch (e, s) {
      log.warning('Error sending HTTP POST request to $url', e, s);
      throw HttpRequestException();
    }
  }

  T _processResponse<T>(http.Response response,
      T Function(Map<String, dynamic>) fromJson, String endpointDescription) {
    if (request_utils.isSuccessCode(response.statusCode)) {
      try {
        var json = convert.jsonDecode(response.body);
        return fromJson(json);
      } catch (e, s) {
        log.warning(
            'Error parsing or deserializing json from response.body', e, s);
        try {
          log.warning('response.body:\n${response.body}');
        } catch (_) {}
        throw JsonProcessingException();
      }
    } else {
      if (response.statusCode == notFound) {
        log.warning(
            'Version API returned status code $notFound for endpoint $endpointDescription');
        throw ResourceNotFoundException();
      } else {
        log.warning('Version API endpoint $endpointDescription '
            'returned non-success code, got ${response.statusCode}');
        throw ResponseNonSuccessfulException();
      }
    }
  }

  Map<String, String> get _authorizationHeader =>
      {'Authorization': _credentials.authorizationHeaderValue};
}

const notFound = 404;

class HttpRequestException implements Exception {
  static const userMessage = '''
Error while sending request to Monarch API. Please check your internet connection and try again.''';
}

class JsonProcessingException implements Exception {
//   static const userMessage = '''
// Error processing http response. Please try again or run `monarch run -v`.''';
  static String userMessage({required String alternateCommand}) => '''
Error processing http response. Please try again or run `$alternateCommand`.''';
}

class ResponseNonSuccessfulException implements Exception {
  static String userMessage({required String alternateCommand}) => '''
Monarch API returned non-successful status code. Please try again or run `$alternateCommand`.''';
}

/// An exception indicating an API returned a 404 status code.
class ResourceNotFoundException implements Exception {
  static String userMessage({required String alternateCommand}) => '''
Monarch API returned 404. Resource not found. Please try again or run `$alternateCommand`.''';
}
