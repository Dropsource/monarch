import 'package:flutter/material.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/widgets/story_list/search_field.dart';
import 'package:monarch_controller/widgets/story_list/story_tree.dart';
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_definitions/monarch_definitions.dart';

import '../../../utils/translations.dart';
import '../components/no_stories_found_text.dart';

class StoryList extends StatefulWidget {
  const StoryList({
    Key? key,
    required this.stories,
    required this.projectName,
    required this.manager,
    this.activeStoryId,
  }) : super(key: key);

  final List<StoryGroup> stories;
  final String projectName;
  final StoryId? activeStoryId;
  final ControllerManager manager;

  @override
  State<StatefulWidget> createState() => StoryListState();
}

class StoryListState extends State<StoryList> {
  final controller = TextEditingController();
  String query = '';
  final _storyListFocusNode = FocusNode();
  final _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _filteredStories =
        widget.manager.filterStories(widget.stories, query);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SearchField(
            controller: controller,
            focusNode: _searchFocusNode,
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
                border: Border.fromBorderSide(
                  BorderSide(width: 1, color: Theme.of(context).dividerColor),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: SingleChildScrollView(
                  child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (_filteredStories.isEmpty) ...[
                    const NoStoriesFoundWidget()
                  ],
                  StoryTree(
                    filteredStories: _filteredStories,
                    query: query,
                    focusNode: _storyListFocusNode,
                    onStorySelected: (storyKey) =>
                        widget.manager.actions!.onActiveStoryChanged(storyKey),
                    // selectionColor: _focused
                  )
                ],
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
    _searchFocusNode.dispose();
    _storyListFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    query = value;
    setState(() {});
  }
}
