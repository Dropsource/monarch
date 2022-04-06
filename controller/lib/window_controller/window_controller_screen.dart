import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/widgets/controls_panel/controlls_panel.dart';
import 'package:monarch_window_controller/window_controller/widgets/story_list/story_list.dart';
import 'package:monarch_window_controller/window_controller/window_controller_manager.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';

class WindowControllerScreen extends StatefulWidget {
  const WindowControllerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UiWindowControllerState();
}

class UiWindowControllerState extends State<WindowControllerScreen> {
  final manager = WindowControllerManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<WindowControllerState>(
          stream: manager.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            }

            final state = snapshot.data!;

            return Container(
              width: 650,
              height: 600,
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 300),
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: Column(
                        children: [
                          const Text('Story List'),
                          if (!state.active) ...[
                            const Text('Loading Stories'),
                          ],
                          if (state is ConnectedWindowControllerState) ...[
                            Expanded(
                              child: StoryList(
                                projectName: state.monarchData.packageName,
                                stories: state.monarchData.metaStoriesMap,
                                activeStoryName: state.activeStoryName,
                                onActiveStoryChange: (name) =>
                                    manager.onActiveStoryChanged(name),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  ControlsPanel(state:state),
                ],
              ),
            );
          }),
    );
  }
}
