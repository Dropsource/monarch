import 'dart:io';
import 'package:io/io.dart';
import 'package:uuid/uuid.dart';
import 'package:monarch_utils/log.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

import 'application_support_directory.dart';
import 'internal_info.dart';
import 'project_config.dart';
import '../../settings.dart' as settings;

class OsInfo {
  final String name;
  final String? version;
  final String? buildVersion;
  final String versionString;

  OsInfo(
      {required this.name,
      this.version,
      this.buildVersion,
      required this.versionString});
}

class UserDeviceId with Log {
  final String id;
  UserDeviceId(this.id);
}

class PlatformBuildToolInfo {
  final String toolName;
  final String version;
  final String? buildVersion;

  PlatformBuildToolInfo(this.toolName, this.version, this.buildVersion);
}

class TimeZone {
  final String name;
  final int offsetInHours;

  TimeZone(this.name, this.offsetInHours);
}

class ContextInfo with Log {
  final bool isLogVerbose;
  final String deployment;
  final InternalInfo internalInfo;

  OsInfo? _osInfo;
  OsInfo? get osInfo => _osInfo;

  UserDeviceId? _userDeviceId;
  UserDeviceId? get userDeviceId => _userDeviceId;

  PlatformBuildToolInfo? _platformBuildToolInfo;
  PlatformBuildToolInfo? get platformBuildToolInfo => _platformBuildToolInfo;

  TimeZone? _timeZone;
  TimeZone? get timeZone => _timeZone;

  ProjectConfig? _projectConfig;
  ProjectConfig? get projectConfig => _projectConfig;
  set projectConfig(ProjectConfig? value) {
    if (_projectConfig == null) {
      _projectConfig = value;
    } else {
      throw StateError('projectConfig is already set');
    }
  }

  TaskRunnerProjectConfig? get taskRunnerProjectConfig {
    if (projectConfig is TaskRunnerProjectConfig) {
      return projectConfig as TaskRunnerProjectConfig;
    }
    return null;
  }

  String get userDeviceIdOrUnknown =>
      userDeviceId?.id ?? 'user-device-id-unknown';

  ContextInfo(this.isLogVerbose, this.internalInfo)
      : deployment = settings.kDeployment;

  Map<String, dynamic> toPropertiesMap() => {
        'user_device_id': userDeviceId?.id,
        'monarch_binaries': {
          'version': internalInfo.binariesVersion,
          'cli_version': internalInfo.cliVersion,
          'desktop_app_version': internalInfo.platformAppVersion,
          'controller_version': internalInfo.controllerVersion,
          'revision': internalInfo.binariesRevision,
        },
        'project_info': {
          'flutter_version': projectConfig?.flutterSdkId.version,
          'flutter_channel': projectConfig?.flutterSdkId.channel,
          'name': projectConfig?.pubspecProjectName,
          'monarch_package_version':
              taskRunnerProjectConfig?.monarchPackageVersion.toString(),
        },
        'dart_version': Platform.version,
        'platform_build_tool_info': {
          'tool_name': platformBuildToolInfo?.toolName,
          'version': platformBuildToolInfo?.version,
          'build_version': platformBuildToolInfo?.buildVersion
        },
        'number_of_processors': Platform.numberOfProcessors,
        'os_info': {
          'name': osInfo?.name,
          'version': osInfo?.version,
          'build_version': osInfo?.buildVersion,
          'version_string': osInfo?.versionString
        },
        'locale_name': Platform.localeName,
        'time_zone': {
          'name': timeZone?.name,
          'offset_in_hours': timeZone?.offsetInHours
        },
        'is_log_verbose': isLogVerbose,
        'deployment': deployment,
      };

  Future<void> readContext() async {
    await Future.wait([
      readOsInfo(),
      readUserDeviceId(),
      readPlatformBuildToolInfo(),
      readTimeZone(),
    ]);
  }

  Future<void> readOsInfo() async {
    Future<String?> _runSwVers(String argument) async {
      final result = await Process.run('sw_vers', [argument]);
      if (result.exitCode == ExitCode.success.code) {
        return result.stdout.trim();
      } else {
        log.warning('command "sw_vers $argument" did not exit successfully, '
            'got exit code: ${result.exitCode}');
        return null;
      }
    }

    Future<String?> _runVer() async {
      final result = await Process.run('ver', [], runInShell: true);
      if (result.exitCode == ExitCode.success.code) {
        return result.stdout.trim();
      } else {
        log.warning('command "ver" did not exit successfully, '
            'got exit code: ${result.exitCode}');
        return null;
      }
    }

    _osInfo = OsInfo(
        name: Platform.operatingSystem,
        version: await futureForPlatform(
            macos: () => _runSwVers('-productVersion'), windows: _runVer),
        buildVersion: await futureForPlatform(
            macos: () => _runSwVers('-buildVersion'),
            windows: () => Future.value('NA')),
        versionString: Platform.operatingSystemVersion);

    log.config('Operating system information, name=${_osInfo!.name} '
        'version="${_osInfo!.version}" build_version=${_osInfo!.buildVersion} ');
  }

  Future<void> readUserDeviceId() async {
    try {
      if (ApplicationSupportDirectory.isValid) {
        final file = ApplicationSupportDirectory.userDeviceIdFile;
        if (!await file.exists()) {
          await file.create(recursive: true);
          await file.writeAsString(Uuid().v4(), flush: true);
          log.config('User device id written to file');
        }
        final id = await file.readAsString();
        _userDeviceId = UserDeviceId(id);
        log.config(
            'User device id read successfully, user_device_id=${_userDeviceId!.id}');
      } else {
        log.warning(ApplicationSupportDirectory.notValidMessage);
      }
    } catch (e, s) {
      log.warning('Errors while reading or creating file', e, s);
    }
  }

  Future<void> readPlatformBuildToolInfo() {
    return futureForPlatform(
        macos: readXcodebuildInfo, windows: readMSBuildInfo);
  }

  Future<void> readXcodebuildInfo([Future<ProcessResult>? cmd]) async {
    try {
      cmd = cmd ?? Process.run('xcodebuild', ['-version']);
      final result = await cmd;
      if (result.exitCode == ExitCode.success.code) {
        final String output = result.stdout;
        final lines = output.split('\n');
        final version = lines[0].substring('Xcode'.length).trim();
        final buildVersion =
            lines[1].substring(('Build version'.length)).trim();
        _platformBuildToolInfo =
            PlatformBuildToolInfo('xcodebuild', version, buildVersion);
        log.config(
            'xcodebuild info, xcode_version=${_platformBuildToolInfo!.version} xcode_build_version=${_platformBuildToolInfo!.buildVersion}');
      } else {
        log.warning(
            '"xcodebuild -version" command did not exit successfully, got exit code: ${result.exitCode}');
      }
    } catch (e, s) {
      log.warning('could not read xcode version', e, s);
    }
  }

  Future<void> readMSBuildInfo([Future<ProcessResult>? cmd]) async {
    try {
      cmd = cmd ?? Process.run('MSBuild', ['-version']);
      final result = await cmd;
      if (result.exitCode == ExitCode.success.code) {
        final String output = result.stdout;
        final lines = output.split('\n');
        final version = lines[lines.length - 1].trim();
        _platformBuildToolInfo =
            PlatformBuildToolInfo('MSBuild', version, null);
        log.config(
            'MSBuild info, msbuild_version=${_platformBuildToolInfo!.version}');
      } else {
        log.warning(
            '"MBBuild -version" command did not exit successfully, got exit code: ${result.exitCode}');
      }
    } catch (e, s) {
      log.warning('could not read MSBuild version', e, s);
    }
  }

  Future<void> readTimeZone() async {
    _timeZone = TimeZone(
        DateTime.now().timeZoneName, DateTime.now().timeZoneOffset.inHours);
    log.config(
        'Time zone info, time_zone_name=${_timeZone!.name} time_zone_offset_in_hours=${_timeZone!.offsetInHours}');
  }
}
