const DEFAULT_PUMPS = 20;

/// Returns a [Future] that completes after the [event loop][] has run the given
/// number of [times] (20 by default).
///
/// [event loop]: https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a
///
/// Awaiting this approximates waiting until all asynchronous work (other than
/// work that's waiting for external resources) completes.
/// 
/// Taken from: https://github.com/dart-lang/test/blob/master/pkgs/test_api/lib/src/frontend/utils.dart
Future pumpEventQueue({int times = DEFAULT_PUMPS}) {
  if (times == 0) return Future.value();
  // Use [new Future] future to allow microtask events to finish. The [new
  // Future.value] constructor uses scheduleMicrotask itself and would therefore
  // not wait for microtask callbacks that are scheduled after invoking this
  // method.
  return Future(() => pumpEventQueue(times: times - 1));
}

/// Returns a [Future] that completes when the function [isTrue] returns false.
/// If the function [isTrue] returns true, this function will pump the event
/// queue a number of [times] and then call [isTrue] again. 
/// 
/// This function is useful to wait on some condition to change.
Future whileTrue(bool Function() isTrue, {int times = DEFAULT_PUMPS}) async {
  await pumpEventQueue(times: times);
  if (isTrue()) {
    return whileTrue(isTrue, times: times);
  }
  else {
    return Future.value();
  }
}
