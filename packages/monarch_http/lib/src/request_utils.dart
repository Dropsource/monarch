import 'package:http/http.dart' as http;
import 'package:monarch_utils/log.dart';

Future<bool> sendRequest(http.Request request, Logger logger) async {
  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (isSuccessCode(response.statusCode)) {
      return true;
    } else {
      logNon200ResponseWarning(logger, request, response);
      logger.warning(request.body);
      return false;
    }
  } catch (e, s) {
    logger.warning('error sending request', e, s);
    return false;
  }
}

bool isSuccessCode(int statusCode) {
  return statusCode >= 200 && statusCode < 300;
}

void logNon200ResponseWarning(
    Logger logger, http.Request request, http.Response response) {
  logger.warning('request returned non-200 response code, '
      'status code: ${response.statusCode}, '
      'url: ${request.url}, '
      'method: ${request.method}');
}

void logRequestAndReponseBodies(
    Logger logger, http.Request request, http.Response response) {
  logger.warning('''
REQUEST:
${request.body}

RESPONSE:
${response.body}''');
}
