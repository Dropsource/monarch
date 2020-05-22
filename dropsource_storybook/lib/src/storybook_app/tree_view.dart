import 'dart:async';

import 'color_palette.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../story_app/active_story.dart';

enum NodeKind { package, directory, file, story }

class Node {
  final String key;
  final String label;
  final NodeKind kind;
  final int depth;
  final List<Node> children;

  bool get hasChildren => children.length > 0;
  bool get isSelectable => kind == NodeKind.story;

  Node({this.key, this.label, this.kind, this.depth, this.children});
}

void findStoriesNodes(Node node, List<Node> list) {
  if (node.kind == NodeKind.story) {
    list.add(node);
  } else {
    for (var child in node.children) {
      findStoriesNodes(child, list);
    }
  }
}

class TreeView extends StatelessWidget {
  final Node node;

  static const double itemWidth = 240;
  static const double itemHeight = 26;

  TreeView({this.node});

  final _selectedNodeStreamController = StreamController<Node>.broadcast();
  Stream<Node> get selectedNodeStream => _selectedNodeStreamController.stream;

  void _onNodeSelected(Node node) {
    if (node.isSelectable) {
      _selectedNodeStreamController.add(node);
      activeStory.setActiveStory(node.key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NodeView(
        node: node,
        onNodeSelected: _onNodeSelected,
        selectedNodeStream: selectedNodeStream);
  }
}

class NodeView extends StatelessWidget {
  final Node node;
  final Function(Node) onNodeSelected;
  final Stream<Node> selectedNodeStream;

  NodeView({this.node, this.onNodeSelected, this.selectedNodeStream});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NodeLabelView(
              node: node,
              onNodeSelected: onNodeSelected,
              selectedNodeStream: selectedNodeStream),
          NodeChildrenView(
              node: node,
              onNodeSelected: onNodeSelected,
              selectedNodeStream: selectedNodeStream)
        ]);
  }
}

class NodeLabelView extends StatefulWidget {
  final Node node;
  final Function(Node) onNodeSelected;
  final Stream<Node> selectedNodeStream;

  NodeLabelView({this.node, this.onNodeSelected, this.selectedNodeStream});

  @override
  State<StatefulWidget> createState() {
    return _NodeLabelViewState();
  }
}

class _NodeLabelViewState extends State<NodeLabelView> {
  bool _isSelected = false;
  StreamSubscription _subscription;

  _NodeLabelViewState();

  @override
  void initState() {
    super.initState();
    _subscription = widget.selectedNodeStream.listen((Node selectedNode) {
      setState(() {
        _isSelected = widget.node == selectedNode;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leadingTabs = '\t\t\t' * (widget.node.depth + 1);
    return InkWell(
        child: Container(
            width: TreeView.itemWidth,
            height: TreeView.itemHeight,
            color: _isSelected ? ColorPalette.celeste : null,
            child: Text('$leadingTabs - ${widget.node.label}',
                style: TextStyle(
                    height: 1.6,
                    color: _isSelected
                        ? ColorPalette.powderedSnow
                        : ColorPalette.darkGrey))),
        onTap: () {
          widget.onNodeSelected(widget.node);
        });
  }
}

class NodeChildrenView extends StatelessWidget {
  final Node node;
  final Function(Node) onNodeSelected;
  final Stream<Node> selectedNodeStream;

  NodeChildrenView({this.node, this.onNodeSelected, this.selectedNodeStream});

  @override
  Widget build(BuildContext context) {
    if (node.children.isEmpty) {
      return Container();
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: node.children
              .map((n) => NodeView(
                  node: n,
                  onNodeSelected: onNodeSelected,
                  selectedNodeStream: selectedNodeStream))
              .toList());
    }
  }
}
