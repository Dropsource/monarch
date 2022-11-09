import 'package:path/path.dart' as p;

String getPrettyCommand(String executable, List<String> arguments) {
  final command = p.basename(executable);
  final tokens = [command, ...arguments];
  return tokens.join(' ');
}
