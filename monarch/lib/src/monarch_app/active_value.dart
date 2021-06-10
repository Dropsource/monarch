import 'dart:async';
import 'package:meta/meta.dart';
import 'package:monarch_utils/log.dart';

abstract class ActiveValue<T> with Log {

  final _controller = StreamController<T>.broadcast();
  Stream<T> get stream => _controller.stream;

  T get value;
  
  set value(T newValue) {
    setValue(newValue);
    _controller.add(value);
    log.fine(valueSetMessage);
  }

  @protected
  void setValue(T newValue);

  @protected
  String get valueSetMessage;

  void close() {
    _controller.close();
  }
}