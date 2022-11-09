import '../monarch_definitions.dart';

class UriMapper implements StandardMapper<Uri> {
  @override
  Uri fromStandardMap(Map<String, dynamic> args) => Uri(
      scheme: args['scheme'],
      host: args['host'],
      port: args['port'],
      path: args['path']);

  @override
  Map<String, dynamic> toStandardMap(Uri obj) => {
        'scheme': obj.scheme,
        'host': obj.host,
        'port': obj.port,
        'path': obj.path,
      };
}
