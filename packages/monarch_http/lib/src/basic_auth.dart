import 'dart:convert' as convert;

class BasicAuth {
  BasicAuth(String username, String password)
      : _authorizationHeaderToken =
            convert.base64Encode(convert.utf8.encode('$username:$password'));

  final String _authorizationHeaderToken;
  String get authorizationHeaderValue => 'Basic $_authorizationHeaderToken';
}
