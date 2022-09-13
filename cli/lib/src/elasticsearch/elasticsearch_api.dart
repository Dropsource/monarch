import 'package:http/http.dart' as http;
import 'package:monarch_utils/log.dart';
import 'dart:convert' as convert;

import '../../settings.dart' as settings;
import 'package:monarch_http/monarch_http.dart' as request_utils;

class IndexData {
  final String index;
  final Map<String, dynamic> properties;

  IndexData(this.index, this.properties);
}

class ElasticsearchApi {
  final _credentials = request_utils.BasicAuth(
      settings.kElasticsearchUsername, settings.kElasticsearchPassword);

  Future<bool> indexDocument(String index, Object data, Logger logger) async {
    return _indexDocument(index, data, logger);
  }

  Future<bool> _indexDocument(String index, Object data, Logger logger) async {
    final url = '${settings.kElasticsearchEndpoint}/$index/_doc?op_type=create';
    final request = http.Request('POST', Uri.parse(url))
      ..body = convert.jsonEncode(data)
      ..headers['Authorization'] = _credentials.authorizationHeaderValue
      ..headers['Content-Type'] = 'application/json';

    return request_utils.sendRequest(request, logger);
  }

  /// Reference:
  /// https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html
  Future<bool> indexDocumentsInBulk(
      Iterable<IndexData> indexDataList, Logger logger) async {
    final url = '${settings.kElasticsearchEndpoint}/_bulk';
    final request = http.Request('POST', Uri.parse(url))
      ..body = _encodeToNewlineDelimitedJson(indexDataList)
      ..headers['Authorization'] = _credentials.authorizationHeaderValue
      ..headers['Content-Type'] = 'application/x-ndjson';

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (request_utils.isSuccessCode(response.statusCode)) {
        final result = convert.jsonDecode(response.body);
        if (result['errors'] == false) {
          return true;
        } else {
          logger.warning('response had success code but result had errors');
          request_utils.logRequestAndReponseBodies(logger, request, response);
          // return true even though there were some errors,
          // some of the documents sent may have been successful,
          // we would have to go through the result of each document,
          // we can make this code more precise in the future
          return true;
        }
      } else {
        request_utils.logNon200ResponseWarning(logger, request, response);
        request_utils.logRequestAndReponseBodies(logger, request, response);
        return false;
      }
    } catch (e, s) {
      logger.warning('error sending request', e, s);
      return false;
    }
  }

  String _encodeToNewlineDelimitedJson(Iterable<IndexData> indexDataList) {
    var stringBuffer = StringBuffer();
    for (var indexData in indexDataList) {
      final action = {
        'index': {'_index': indexData.index, 'op_type': 'create'}
      };
      stringBuffer.writeln(convert.jsonEncode(action));
      stringBuffer.writeln(convert.jsonEncode(indexData.properties));
    }
    return stringBuffer.toString();
  }
}
