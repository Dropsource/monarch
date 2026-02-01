Read:
- docs/monarch-architecture.md
- docs/local-dev.md
- CHANGELOG.md

If fvm is available, use it.

# Commit guidelines
- Use conventional commits (e.g., feat:, fix:, chore:)
- Use scopes like cli, controller, macos, windows, tools, monarch package, monarch_utils, monarch_grpc, etc.
- Commits can be one-line, or, if needed, they can be one line and a description
- The description should be a brief paragraph
- Do not include Co-Authored-By

# Building and testing

## Build
- `fvm dart tools/build.dart all` builds the CLI, controller, preview_api, and platform binaries
- `fvm dart tools/build.dart cli` rebuilds just the CLI binary (faster)
- Output goes to `out/monarch/`

## Integration tests
- Located in `test/test_*` directories (test_localizations, test_themes, test_stories, test_create)
- Run via: `fvm dart tools/test.dart -m test/test_localizations -f /path/to/flutter/sdk`
- Tests require the built CLI binary (`out/monarch/bin/monarch`)
- The test script sets `MONARCH_EXE` and `FLUTTER_EXE` env vars; running `dart test` directly won't work
- Each test launches a full monarch app via `test_process`, so tests are slow (~30s each)
- To debug a failing integration test: run `monarch run --verbose` in the test project directory and compare the output to the test expectations

## Testing local monarch package changes
- Change `test/test_*/pubspec.yaml` to use a path dependency: `monarch: {path: ../../packages/monarch}`
- This ensures integration tests use local source instead of the pub.dev version

