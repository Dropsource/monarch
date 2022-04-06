import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monarch_window_controller/window_controller/data/monarch_data.dart';
import 'package:monarch_window_controller/window_controller/window_controller_state.dart';

import '../../../main.dart';

class ControlsPanel extends StatelessWidget {
  final WindowControllerState state;

  const ControlsPanel({required this.state, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: controlsWidth,
      color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [

            ],
          )
        ],
      ),
    );
  }
}
