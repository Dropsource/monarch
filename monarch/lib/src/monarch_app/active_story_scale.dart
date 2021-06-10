import 'active_value.dart';

const defaultStoryScale = 1.0;

class ActiveStoryScale extends ActiveValue<double> {
  double _value = defaultStoryScale;
  
  @override
  double get value => _value;
  
  @override
  void setValue(double newValue) {
    _value = newValue;
  }

  @override
  String get valueSetMessage => 'active story scale set: $value';
}

final activeStoryScale = ActiveStoryScale();
