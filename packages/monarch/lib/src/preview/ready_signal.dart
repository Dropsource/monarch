import 'dart:async';

class ReadySignal {
  bool _isReady = false;
  bool get isReady => _isReady;

  final _changeStreamController = StreamController<bool>.broadcast();
  Stream<bool> get changeStream => _changeStreamController.stream;

  void loading() {
    _isReady = false;
    _changeStreamController.add(_isReady);
  }

  void ready() {
    _isReady = true;
    _changeStreamController.add(_isReady);
  }
}

final readySignal = ReadySignal();
