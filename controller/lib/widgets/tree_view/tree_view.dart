///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monarch_controller/widgets/tree_view/primitives/key_provider.dart';

import 'builder.dart';
import 'copy_tree_nodes.dart';
import 'primitives/tree_controller.dart';
import 'primitives/tree_node.dart';

/// Tree view with collapsible and expandable nodes.
class TreeView extends StatefulWidget {
  /// List of root level tree nodes.
  final List<TreeNode> nodes;

  /// Horizontal indent between levels.
  final double? indent;

  /// Size of the expand/collapse icon.
  final double? iconSize;

  /// Tree controller to manage the tree state.
  final TreeController treeController;

  final FocusNode? focusNode;

  TreeView(
      {Key? key,
      required List<TreeNode> nodes,
      this.indent = 40,
      this.iconSize,
      this.focusNode,
      required this.treeController})
      : nodes = copyTreeNodes(nodes, treeController.keyProvider),
        super(key: key);

  @override
  _TreeViewState createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late TreeController _controller;
  late KeyProvider keyProvider;

  @override
  void initState() {
    _controller = widget.treeController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (focused) =>
          setState(() => _controller.hasFocus = focused),
      onKey: (node, event) {
        if (event is! RawKeyDownEvent) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          return _handleKeyEvent(node, event, () => _controller.onKeyUp());
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          return _handleKeyEvent(node, event, () => _controller.onKeyDown());
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          return _handleKeyEvent(node, event, () => _controller.onKeyLeft());
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          return _handleKeyEvent(node, event, () => _controller.onKeyRight());
        }
        return KeyEventResult.ignored;
      },
      child: buildNodes(widget.nodes, widget.indent, _controller,
          widget.iconSize, _updateRoot, _onFocus),
    );
  }

  KeyEventResult _handleKeyEvent(node, event, bool Function() test) {
    if (event is! RawKeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final result = test();
    if (result) setState(() {});
    return KeyEventResult.handled;
  }

  void _updateRoot() {
    setState(() {});
  }

  void _onFocus() {
    if (!_controller.hasFocus) {
      setState(() => _controller.hasFocus = true);
    }
  }
}
