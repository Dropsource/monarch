import 'package:flutter/widgets.dart';
import 'package:monarch_utils/log.dart';

final _logger = Logger('Start');

/// A widget with a callback which is called when `State.reassemble` is called.
/// `State.reassemble` is "called whenever the application is reassembled during
/// debugging, for example during hot reload."
///
/// https://stackoverflow.com/questions/55281077/how-to-detect-hot-reload-inside-the-code-of-a-flutter-app
class ReassembleListener extends StatefulWidget {
  const ReassembleListener(
      {Key? key, required this.onReassemble, required this.child})
      : super(key: key);

  final VoidCallback onReassemble;
  final Widget child;

  @override
  _ReassembleListenerState createState() => _ReassembleListenerState();
}

class _ReassembleListenerState extends State<ReassembleListener> {
  @override
  void reassemble() {
    super.reassemble();
    widget.onReassemble();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
