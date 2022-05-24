///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TreeController? treeController;

  final FocusNode? focusNode;

  TreeView({
    Key? key,
    required List<TreeNode> nodes,
    this.indent = 40,
    this.iconSize,
    this.treeController,
    this.focusNode,
  })  : nodes = copyTreeNodes(nodes),
        super(key: key);

  @override
  _TreeViewState createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late TreeController _controller;

  late VoidCallback updateRoot = () => setState(() {});
  late VoidCallback onFocus = () {
    if (!_controller.hasFocus) {
      setState(() => _controller.hasFocus = true);
    }
  };

  @override
  void initState() {
    _controller = widget.treeController ?? TreeController();
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
          _controller.onKeyUp();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _controller.onKeyDown();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _controller.onKeyLeft();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _controller.onKeyRight();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: buildNodes(widget.nodes, widget.indent, _controller,
          widget.iconSize, updateRoot, onFocus),
    );
  }
}
