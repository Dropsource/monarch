# Contributing to Monarch

We have worked hard to make the contribution process as painless as possible.
This repo includes various build scripts which should make it easy to contribute
to Monarch. The scripts can be run from macOS and Windows.

The steps below will help you set up Monarch in your local environment.

1. Clone this repo to your local environment.

2. Create a cli/lib/settings.dart file with these contents:
```
const DEPLOYMENT = 'local';
const ELASTICSEARCH_ENDPOINT = '';
const ELASTICSEARCH_USERNAME = '';
const ELASTICSEARCH_PASSWORD = '';
const VERSION_API_URL = '';
```

3. Create a file tools/local_settings.yaml, and populate it with the paths to your 
   local flutter sdks:
```
local_flutter_sdks:
  - /Users/bob/development/flutter-sdks/beta
  - /Users/bob/development/flutter-sdks/stable
```

4. Build all the monarch modules:
```
$ dart tools/build.dart
```

If you want to build a specific module, then you can run either of these scripts:
```
$ dart tools/build_cli.dart
$ dart tools/build_controller.dart
$ dart tools/build_platform.dart 
```

The build scripts will output the built artifacts to the out directory.

5. Run the version of monarch you just built against a new flutter project:
```
$ flutter create my_project
$ cd my_project
$ /path/to/out/monarch/bin/monarch init
$ /path/to/out/monarch/bin/monarch run --verbose
```

To make things easier, you could add the out/monarch/bin directory to your PATH.

6. If you would like to propose a change please submit a PR. Do not forget
to run the tests:
```
$ dart tools/test.dart
```
