# Monarch Integration Tests

This directory contains Monarch integration tests. These tests exercise
the Monarch binaries and Monarch source code generation. They execute `flutter`
and `monarch` processes.

The Monarch integration tests can:
- Test the Monarch binaries against test projects.
- Test the Monarch source code generation.
- Test using various flutter versions.

### Directory structure

- test_create: This directory contains integration tests to test Monarch 
  on new projects. It is not a flutter or dart project. Each test creates 
  its own flutter project in a temporary working directory.
- test_localizations: Flutter project to test monarch localizations annotations.
- test_stories: Flutter project to test monarch stories code generation.
- test_themes: Flutter project to test monarch themes annotations.
- utils: Utils for Monarch integration tests.

### Run all the tests using test.dart 
Before running the tests, make sure you have build the monarch binaries:
```
$ dart tools/build.dart
```
The command above will output the monarch binaries to the `out` directory.

To run all the test in the Monarch repo (unit tests and integration tests), run:
```
$ dart tools/test.dart
```
The dart script above will run the tests using the flutter sdks you have declared 
in `tools/local_settings.yaml`. And the monarch exe in the `out` directory.

### Run a single integration test
If you want to run a single test or a group of tests, there are a few things to
keep in mind:

- The flutter and monarch executables to test need to be sourced in your PATH or 
  they need to be set as environment variables FLUTTER_EXE and MONARCH_EXE
- The integration tests need to be run sequentially, use the `-j 1` flag. 
  Example: `dart test -j 1`


Example: running all tests in test_themes and sourcing flutter and monarch executables in your path.
```
// 1. source flutter sdk you want to use in your PATH
// 2. source monarch exe you want to use in your PATH
$ cd test_themes
$ dart test -j 1
```

Example: running one test and setting environment variables
```
$ cd test_themes
$ FLUTTER_EXE=/path/to/flutter-sdk/bin/flutter MONARCH_EXE=/path/to/monarch/bin/monarch dart test test/select_themes_test.dart
```

Example: Run test in verbose mode to see log messages and heartbeats.
```
$ cd test_create
$ VERBOSE=1 dart test test/monarch_init_test.dart
```

### Run tests on Windows 
For example, to pass environment variables needed by the test_create tests,
using Powershell, go to the test_create directory and run:
```
PS C:\PATH\TO\monarch\test\test_create> $env:FLUTTER_EXE='C:\PATH\TO\bin\flutter'; $env:MONARCH_EXE='C:\PATH\TP\monarch\out\monarch\bin\monarch.exe'; dart test .\test\smoke_test.dart
```

Run in verbose mode:
```
PS > $env:VERBOSE=1; dart test -j 1
```
