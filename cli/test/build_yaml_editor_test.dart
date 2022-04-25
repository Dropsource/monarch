import 'package:monarch_cli/src/init/build_yaml_editor.dart';
import 'package:test/test.dart';

const sourcesList = [r'$package$', 'lib/**', 'stories/**'];

const expected1 = r'''
targets:
  $default:
    sources:
      - $package$
      - lib/**
      - stories/**''';

const expected2 = r'''
targets: 
  $default:
    sources:
      - $package$
      - lib/**
      - stories/**
''';

const expected3 = r'''
targets:
  $default: 
    sources:
      - $package$
      - lib/**
      - stories/**
''';

const expected4 = r'''
targets:
  $default:
    sources: 
      - $package$
      - lib/**
      - stories/**
''';

const expected5 = r'''
targets:
  $default:
    sources:
      - $package$
      - lib/**
      - stories/**
      - foo
''';

void main() {
  group('BuildYamlEditor tests', () {
    void verifySourcesAreSet(String contents, String expectedContents) {
      final editor = BuildYamlEditor(contents);
      editor.setDefaultTargetSources(sourcesList);
      expect(editor.newContents, expectedContents);
    }

    group('sets sources', () {
      test('empty', () {
        verifySourcesAreSet('''
''', expected1);
      });

      test('targets', () {
        verifySourcesAreSet('''
targets:
''', expected2);
      });

      test('targets, default', () {
        verifySourcesAreSet(r'''
targets:
  $default:
''', expected3);
      });

      test('targets, default, sources', () {
        verifySourcesAreSet(r'''
targets:
  $default:
    sources:
''', expected4);
      });

      test('targets, default, sources, item', () {
        verifySourcesAreSet(r'''
targets:
  $default:
    sources:
      - foo
''', expected5);
      });

      test('does not duplicate sources', () {
        final editor = BuildYamlEditor(r'''
targets:
  $default:
    sources:
      - $package$
      - lib/**
      - stories/**
''');
        editor.setDefaultTargetSources(sourcesList);
        expect(editor.newContents, r'''
targets:
  $default:
    sources:
      - $package$
      - lib/**
      - stories/**
''');
      });
    });
  });
}
