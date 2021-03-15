import 'dart:convert' as convert;

class BasicAuth {
  BasicAuth(String username, String password) {
    final up = convert.utf8.encode('$username:$password');
    _authorizationHeaderValue = 'Basic ${convert.base64Encode(up)}';
  }

  String _authorizationHeaderValue;
  String get authorizationHeaderValue => _authorizationHeaderValue;
}
