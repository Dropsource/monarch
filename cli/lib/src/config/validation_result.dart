class ValidationResult {
  final List<String> errors;
  final List<String> warnings;

  bool get isValid => errors.isEmpty;

  ValidationResult(this.errors, this.warnings);
}
