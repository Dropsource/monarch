abstract class Validator {
  final validationErrors = <String>[];
  bool get isValid => validationErrors.isEmpty;
  Future<void> validate();
  String get foundErrorsMessage;
  String validationErrorsPretty() {
    final errors = validationErrors.map((error) => '- $error').join('\n');
    return '$foundErrorsMessage:\n$errors';
  }
}
