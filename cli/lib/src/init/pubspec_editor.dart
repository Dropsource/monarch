import 'package:monarch_utils/log.dart';
import 'package:yaml_edit/yaml_edit.dart';
import 'package:yaml/yaml.dart';

class PubspecEditor with Log {
  final YamlEditor _editor;

  String get newContents => _editor.toString();

  PubspecEditor(String pubspec) : _editor = YamlEditor(pubspec);

  /// Sets a package, [dependenciesName] could be `dependencies`,
  /// `dev_dependencies`, etc.
  void setPackage(
      String dependenciesName, String packageName, String packageVersion) {
    log.fine(
        'Setting $packageName: $packageVersion under $dependenciesName node');
    final dependenciesNode =
        _editor.parseAt([dependenciesName], orElse: () => wrapAsYamlNode(null));
    if (dependenciesNode.value == null || dependenciesNode is YamlScalar) {
      log.fine('$dependenciesName node is missing or empty');
      _editor.update([dependenciesName], {packageName: packageVersion});
    } else {
      log.fine('$dependenciesName node is present');
      _editor.update([dependenciesName, packageName], packageVersion);
    }
  }
}
