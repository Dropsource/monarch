///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'primitives/key_provider.dart';
import 'primitives/tree_node.dart';

/// Copies nodes to unmodifiable list, assigning missing keys and checking for duplicates.
List<TreeNode> copyTreeNodes(List<TreeNode>? nodes) {
  return _copyNodesRecursively(nodes, KeyProvider())!;
}

List<TreeNode>? _copyNodesRecursively(
    List<TreeNode>? nodes, KeyProvider keyProvider) {
  if (nodes == null) {
    return null;
  }
  return List.unmodifiable(nodes.map((n) {
    return TreeNode(
      key: keyProvider.key(n.key),
      content: n.content,
      children: _copyNodesRecursively(n.children, keyProvider),
      onTap: n.onTap,
      updateRoot: n.updateRoot,
    );
  }));
}
