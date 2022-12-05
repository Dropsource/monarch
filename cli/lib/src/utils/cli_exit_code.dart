class CliExitCode {
  final int code;
  final String description;
  final bool isFailure;

  const CliExitCode(this.code, this.description, this.isFailure);

  bool absEqual(int code_) => code.abs() == code_.abs();
}

class CliExitCodes {
  static const userTerminated =
      CliExitCode(2, 'CLI terminated by user request (CTRL+C)', false);
}
