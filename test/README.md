# Monarch Integration Tests

This directory contains Monarch integration tests. These tests exercise
the Monarch binaries and Monarch source code generation. These tests run `flutter`
and `monarch` processes.

The Monarch integration tests can:
- Test the Monarch binaries against test projects.
- Test the Monarch source code generation.
- Test using various flutter versions.

### Directory structure

- test_create: This directory contains integration tests to test Monarch on new projects. It is not a flutter or dart project. Each test creates its own flutter 
project in a temporary working directory.
- test_localizations: Flutter project to test monarch localizations annotations.
- test_stories: Flutter project to test monarch stories code generation.
- test_themes: Flutter project to test monarch themes annotations.
- utils: Utils for Monarch integration tests.


### todo

- [ ] document how to run integration test
```
dart tool/run_tests.dart
dart test test/first_run_test.dart
```

Run test in verbose mode to see log messages and heartbeats.
```
VERBOSE=1 dart test monarch_init_test.dart
```

Run using 1 thread (1 job)
```
dart test . -j 1
dart test -j 1
```