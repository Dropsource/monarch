import 'dart:async';

class Debouncer {
  Timer? timer;

  void debounce(Duration duration, void Function() callback) {
    timer?.cancel();
    timer = Timer(duration, () {
      timer?.cancel();
      callback();
    });
  }
}
