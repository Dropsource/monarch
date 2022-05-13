import 'dart:io';
import 'package:monarch_utils/log.dart';
import 'package:path/path.dart' as p;
import 'monarch_binaries.dart';

class InternalInfo {
  final String binariesRevision;
  final String binariesVersion;
  final String cliVersion;
  final String controllerVersion;
  final String minFlutterVersion;
  final String platformAppVersion;

  const InternalInfo(
      {required this.binariesRevision,
      required this.binariesVersion,
      required this.cliVersion,
      required this.controllerVersion,
      required this.minFlutterVersion,
      required this.platformAppVersion});
}

final _logger = Logger('InternalInfo');

Future<InternalInfo> readInternalFiles(MonarchBinaries monarchBinaries) async {
  var internal = InternalInfo(
      binariesRevision:
          await _readInternalFile('binaries_revision.txt', monarchBinaries),
      binariesVersion:
          await _readInternalFile('binaries_version.txt', monarchBinaries),
      cliVersion: await _readInternalFile('cli_version.txt', monarchBinaries),
      controllerVersion:
          await _readInternalFile('controller_version.txt', monarchBinaries),
      minFlutterVersion:
          await _readInternalFile('min_flutter_version.txt', monarchBinaries),
      platformAppVersion:
          await _readInternalFile('platform_app_version.txt', monarchBinaries));

  _logger.config('commit_hash=${internal.binariesRevision}');
  _logger.config('monarch binaries:'
      ' version=${internal.binariesVersion}'
      ' cli_version=${internal.cliVersion}'
      ' controller_verison=${internal.controllerVersion}'
      ' platform_app_version=${internal.platformAppVersion}');

  return internal;
}

Future<String> _readInternalFile(
    String name, MonarchBinaries monarchBinaries) async {
  var path = p.join(monarchBinaries.internalDirectory.path, 'name');
  var file = File(path);
  if (await file.exists()) {
    var contents = await file.readAsString();
    return contents.trim();
  } else {
    _logger.warning('Internal file missing ${file.path}');
    return '';
  }
}
