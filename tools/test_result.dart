
class TestResult {
  final String module;
  final int exitCode;
  bool get passed => exitCode == 0;

  TestResult(this.module, this.exitCode);
  
  @override
  String toString() => '$module tests ${exitCode == 0 ? 'passed' : 'FAILED'}';
}
