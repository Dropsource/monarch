# Monarch Integration Tests

This directory contains Monarch integration tests. Unit tests are inside the various monarch sub-directories.

The Monarch integration tests can:
- Test the Monarch binaries against test projects.
- Test the Monarch source code generation.
- Test using various flutter versions.

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