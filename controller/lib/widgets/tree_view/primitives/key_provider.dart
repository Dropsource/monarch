///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/material.dart';

class _TreeNodeKey extends ValueKey {
  const _TreeNodeKey(dynamic value) : super(value);
}

/// Provides unique keys and verifies duplicates.
class KeyProvider {
  int _nextIndex = 0;
  final Set<Key> _keys = <Key>{};

  /// If [originalKey] is null, generates new key, otherwise verifies the key
  /// was not met before.
  Key key(Key? originalKey) {
    if (originalKey == null) {
      return _TreeNodeKey(_nextIndex++);
    }
    if (_keys.contains(originalKey)) {
      throw ArgumentError('There should not be nodes with the same kays. '
          'Duplicate value found: $originalKey.');
    }
    _keys.add(originalKey);
    return originalKey;
  }
}
