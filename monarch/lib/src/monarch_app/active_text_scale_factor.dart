import 'active_value.dart';

const defaultTextScaleFactor = 1.0;

class ActiveTextScaleFactor extends ActiveValue<double> {
  double _activeTextScaleFactor = defaultTextScaleFactor;

  @override
  double get value => _activeTextScaleFactor;

  @override
  void setValue(double newValue) {
    _activeTextScaleFactor = newValue;
  }

  @override
  String get valueSetMessage => 'active text scale factor set: $value';
}

final activeTextScaleFactor = ActiveTextScaleFactor();
