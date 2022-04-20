import 'clean.dart' as clean;
import 'build_cli.dart' as build_cli;
import 'build_platform.dart' as build_platform;
import 'build_controller.dart' as build_controller;

void main() {
  clean.main();
  build_cli.main();
  build_platform.main();
  build_controller.main();
}