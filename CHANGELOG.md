
# Dependency upgrade notes

## The `build` package and dart:mirrors
- The `build` package is a regular dependency (not dev) because builders live in `lib/src/builders/`
- `build 2.5+` and `build 3.x` depend on `build_runner_core` which imports `dart:mirrors`
- `dart:mirrors` is NOT supported in Flutter's Dart runtime, so any transitive import of it crashes the Flutter isolate with: `Dart Error: error: import of dart:mirrors is not supported in the current Dart runtime`
- The monarch app will appear to hang with no error in stdout; check the log file for the dart:mirrors error
- Safe versions: `build ^2.0.0` (resolves to 2.4.2, no build_runner_core dep) or `build ^4.0.0` (dropped build_runner_core dep)

## build_runner log format change
- `build_runner 2.4.x` outputs `[WARNING] monarch:builder on lib/file.dart:` (bracket format)
- `build_runner 2.10.x` outputs `W monarch:builder on lib/file.dart:` (single-letter prefix)
- The CLI parses build_runner stdout to extract log levels and forward WARNING+ messages to the user
- The regex and parser in `cli/lib/src/task_runner/` handles both formats
- The CLI also strips the build_runner prefix and indentation from forwarded messages so warning boxes display cleanly

## Flutter SDK version pins
- Flutter pins `test_api` to a specific version; upgrading `analyzer` may require a newer Flutter SDK to resolve dependencies
- Check `test_api` compatibility when upgrading analyzer/source_gen