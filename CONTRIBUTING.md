## WIP

After cloning this repo:

1. Create a cli/lib/settings.dart file with these contents:
```
const DEPLOYMENT = 'local';
const ELASTICSEARCH_ENDPOINT = '';
const ELASTICSEARCH_USERNAME = '';
const ELASTICSEARCH_PASSWORD = '';
const VERSION_API_URL = '';
```
_Ideally the contributor should not have to create the settings.dart file._
_After changing usage or analytics requirements, this will probably change._

2. Create a file tools/local_settings.yaml, and populate it with the paths to your 
   local flutter sdks:
```
local_flutter_sdks:
  - /Users/bob/development/flutter-sdks/beta
  - /Users/bob/development/flutter-sdks/stable
```

3. Build all the monarch modules:
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

4. Run monarch against an existing or new flutter project:
```
// use flutter beta channel for now (or flutter >= 3.0.0)
$ flutter create my_project
$ cd my_project
$ /path/to/out/monarch/bin/monarch init
$ /path/to/out/monarch/bin/monarch run --verbose
```
