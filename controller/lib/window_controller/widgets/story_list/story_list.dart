import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/default_theme.dart';
import 'package:monarch_window_controller/window_controller/widgets/components/text.dart';
import 'package:monarch_window_controller/window_controller/widgets/story_list/search_field.dart';
import 'package:monarch_window_controller/window_controller/widgets/tree_view/flutter_simple_treeview.dart';

import '../../../utils/translations.dart';
import '../components/no_stories_found_text.dart';

class StoryList extends StatefulWidget {
  const StoryList({
    Key? key,
    required this.stories,
    required this.projectName,
    this.activeStoryName,
    this.onActiveStoryChange,
  }) : super(key: key);

  final Map<String, MetaStories> stories;
  final String projectName;
  final String? activeStoryName;
  final Function(String)? onActiveStoryChange;

  @override
  State<StatefulWidget> createState() => StoryListState();
}

class StoryListState extends State<StoryList> {
  final controller = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    final _filteredStories = widget.stories.entries.where(_filterStories);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SearchField(
            controller: controller,
            canReset: query.isNotEmpty,
            hint: Translations.of(context)?.text('story_list.search'),
            onReset: () {
              query = '';
              controller.text = query;
              setState(() {});
            },
            onChanged: _onQueryChanged,
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.fromBorderSide(BorderSide(
                    width: 1, color: Theme.of(context).dividerColor)),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: SingleChildScrollView(
                  child: Container(
                child: _filteredStories.isEmpty
                    ? const NoStoriesFoundWidget()
                    : TreeView(
                        nodes: _filteredStories
                            .map((e) => TreeNode(
                                  content: TextBody1(e.key),
                                  children: e.value.storiesNames
                                      .map(
                                        (name) => TreeNode(
                                          content: GestureDetector(
                                            onTap: () => widget
                                                .onActiveStoryChange
                                                ?.call(name),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                left: 40,
                                                top: 4,
                                                bottom: 4,
                                                right: 8,
                                              ),
                                              color:
                                                  widget.activeStoryName == name
                                                      ? Colors.blue
                                                      : Colors.transparent,
                                              child: TextBody1(
                                                name,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ))
                            .toList()),
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    query = value;

    setState(() {});
  }

  bool _filterStories(MapEntry<String, MetaStories> element) {
    final name = element.key;
    final storyNames = element.value.storiesNames;

    return name.contains(query) ||
        storyNames.where((element) => element.contains(query)).isNotEmpty;
  }
}
