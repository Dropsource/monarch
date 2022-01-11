import 'active_value.dart';

class ActiveStoryError extends ActiveValue<String?> {
  String? _message;

  @override
  String? get value => _message;

  @override
  void setValue(String? newValue) {
    _message = newValue;
  }

  @override
  String get valueSetMessage =>
      value == null ? 'active story error reset' : 'active story error set';
}

final activeStoryError = ActiveStoryError();
