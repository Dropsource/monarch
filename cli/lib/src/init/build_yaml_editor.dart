import 'package:monarch_utils/log.dart';
import 'package:yaml_edit/yaml_edit.dart';
import 'package:yaml/yaml.dart';

const targetsKey = 'targets';
const defaultKey = r'$default';
const sourcesKey = 'sources';

class BuildYamlEditor with Log {
  final YamlEditor _editor;

  String get newContents => _editor.toString();

  BuildYamlEditor(String contents) : _editor = YamlEditor(contents);

  void setDefaultTargetSources(List<String> sourcesList) {
    if (_editor.toString().isEmpty) {
      _editor.update([], {
        targetsKey: {
          defaultKey: {sourcesKey: sourcesList}
        }
      });
      return;
    }

    {
      final node =
          _editor.parseAt([targetsKey], orElse: () => wrapAsYamlNode(null));
      if (node.value == null || node is YamlScalar) {
        _editor.update([
          targetsKey
        ], {
          defaultKey: {sourcesKey: sourcesList}
        });
        return;
      }
    }

    {
      final node = _editor.parseAt([targetsKey, defaultKey],
          orElse: () => wrapAsYamlNode(null));
      if (node.value == null || node is YamlScalar) {
        _editor.update([targetsKey, defaultKey], {sourcesKey: sourcesList});
        return;
      }
    }

    {
      final node = _editor.parseAt([targetsKey, defaultKey, sourcesKey],
          orElse: () => wrapAsYamlNode(null));
      if (node.value == null || node is YamlScalar) {
        _editor.update([targetsKey, defaultKey, sourcesKey], sourcesList);
        return;
      } else if (node is YamlList) {
        for (var i = sourcesList.length - 1; i >= 0; i--) {
          if (!node.contains(sourcesList[i])) {
            _editor.insertIntoList(
                [targetsKey, defaultKey, sourcesKey], 0, sourcesList[i]);
          }
        }
        return;
      } else {
        throw 'Unexpected node type at path [$targetsKey, $defaultKey, $sourcesKey]';
      }
    }
  }
}

// targets:
//   $default:
//     sources:
//       - $package$
//       - lib/**
//       - stories/**
