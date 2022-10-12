///
//  Generated code. Do not modify.
//  source: monarch_grpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use referenceDataInfoDescriptor instead')
const ReferenceDataInfo$json = const {
  '1': 'ReferenceDataInfo',
  '2': const [
    const {'1': 'devices', '3': 1, '4': 3, '5': 11, '6': '.monarch_grpc.DeviceInfo', '10': 'devices'},
    const {'1': 'standardThemes', '3': 2, '4': 3, '5': 11, '6': '.monarch_grpc.ThemeInfo', '10': 'standardThemes'},
    const {'1': 'scales', '3': 3, '4': 3, '5': 11, '6': '.monarch_grpc.ScaleInfo', '10': 'scales'},
  ],
};

/// Descriptor for `ReferenceDataInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List referenceDataInfoDescriptor = $convert.base64Decode('ChFSZWZlcmVuY2VEYXRhSW5mbxIyCgdkZXZpY2VzGAEgAygLMhgubW9uYXJjaF9ncnBjLkRldmljZUluZm9SB2RldmljZXMSPwoOc3RhbmRhcmRUaGVtZXMYAiADKAsyFy5tb25hcmNoX2dycGMuVGhlbWVJbmZvUg5zdGFuZGFyZFRoZW1lcxIvCgZzY2FsZXMYAyADKAsyFy5tb25hcmNoX2dycGMuU2NhbGVJbmZvUgZzY2FsZXM=');
@$core.Deprecated('Use projectDataInfoDescriptor instead')
const ProjectDataInfo$json = const {
  '1': 'ProjectDataInfo',
  '2': const [
    const {'1': 'packageName', '3': 1, '4': 1, '5': 9, '10': 'packageName'},
    const {'1': 'storiesMap', '3': 2, '4': 3, '5': 11, '6': '.monarch_grpc.ProjectDataInfo.StoriesMapEntry', '10': 'storiesMap'},
    const {'1': 'projectThemes', '3': 3, '4': 3, '5': 11, '6': '.monarch_grpc.ThemeInfo', '10': 'projectThemes'},
    const {'1': 'localizations', '3': 4, '4': 3, '5': 11, '6': '.monarch_grpc.LocalizationInfo', '10': 'localizations'},
  ],
  '3': const [ProjectDataInfo_StoriesMapEntry$json],
};

@$core.Deprecated('Use projectDataInfoDescriptor instead')
const ProjectDataInfo_StoriesMapEntry$json = const {
  '1': 'StoriesMapEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.monarch_grpc.StoriesInfo', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `ProjectDataInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectDataInfoDescriptor = $convert.base64Decode('Cg9Qcm9qZWN0RGF0YUluZm8SIAoLcGFja2FnZU5hbWUYASABKAlSC3BhY2thZ2VOYW1lEk0KCnN0b3JpZXNNYXAYAiADKAsyLS5tb25hcmNoX2dycGMuUHJvamVjdERhdGFJbmZvLlN0b3JpZXNNYXBFbnRyeVIKc3Rvcmllc01hcBI9Cg1wcm9qZWN0VGhlbWVzGAMgAygLMhcubW9uYXJjaF9ncnBjLlRoZW1lSW5mb1INcHJvamVjdFRoZW1lcxJECg1sb2NhbGl6YXRpb25zGAQgAygLMh4ubW9uYXJjaF9ncnBjLkxvY2FsaXphdGlvbkluZm9SDWxvY2FsaXphdGlvbnMaWAoPU3Rvcmllc01hcEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5Ei8KBXZhbHVlGAIgASgLMhkubW9uYXJjaF9ncnBjLlN0b3JpZXNJbmZvUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use selectionsStateInfoDescriptor instead')
const SelectionsStateInfo$json = const {
  '1': 'SelectionsStateInfo',
  '2': const [
    const {'1': 'storyId', '3': 1, '4': 1, '5': 11, '6': '.monarch_grpc.StoryIdInfo', '10': 'storyId'},
    const {'1': 'device', '3': 2, '4': 1, '5': 11, '6': '.monarch_grpc.DeviceInfo', '10': 'device'},
    const {'1': 'theme', '3': 3, '4': 1, '5': 11, '6': '.monarch_grpc.ThemeInfo', '10': 'theme'},
    const {'1': 'locale', '3': 4, '4': 1, '5': 11, '6': '.monarch_grpc.LocaleInfo', '10': 'locale'},
    const {'1': 'textScaleFactor', '3': 5, '4': 1, '5': 1, '10': 'textScaleFactor'},
    const {'1': 'scale', '3': 6, '4': 1, '5': 11, '6': '.monarch_grpc.ScaleInfo', '10': 'scale'},
    const {'1': 'dock', '3': 7, '4': 1, '5': 11, '6': '.monarch_grpc.DockInfo', '10': 'dock'},
    const {'1': 'visualDebugFlags', '3': 8, '4': 3, '5': 11, '6': '.monarch_grpc.SelectionsStateInfo.VisualDebugFlagsEntry', '10': 'visualDebugFlags'},
  ],
  '3': const [SelectionsStateInfo_VisualDebugFlagsEntry$json],
};

@$core.Deprecated('Use selectionsStateInfoDescriptor instead')
const SelectionsStateInfo_VisualDebugFlagsEntry$json = const {
  '1': 'VisualDebugFlagsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 8, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `SelectionsStateInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectionsStateInfoDescriptor = $convert.base64Decode('ChNTZWxlY3Rpb25zU3RhdGVJbmZvEjMKB3N0b3J5SWQYASABKAsyGS5tb25hcmNoX2dycGMuU3RvcnlJZEluZm9SB3N0b3J5SWQSMAoGZGV2aWNlGAIgASgLMhgubW9uYXJjaF9ncnBjLkRldmljZUluZm9SBmRldmljZRItCgV0aGVtZRgDIAEoCzIXLm1vbmFyY2hfZ3JwYy5UaGVtZUluZm9SBXRoZW1lEjAKBmxvY2FsZRgEIAEoCzIYLm1vbmFyY2hfZ3JwYy5Mb2NhbGVJbmZvUgZsb2NhbGUSKAoPdGV4dFNjYWxlRmFjdG9yGAUgASgBUg90ZXh0U2NhbGVGYWN0b3ISLQoFc2NhbGUYBiABKAsyFy5tb25hcmNoX2dycGMuU2NhbGVJbmZvUgVzY2FsZRIqCgRkb2NrGAcgASgLMhYubW9uYXJjaF9ncnBjLkRvY2tJbmZvUgRkb2NrEmMKEHZpc3VhbERlYnVnRmxhZ3MYCCADKAsyNy5tb25hcmNoX2dycGMuU2VsZWN0aW9uc1N0YXRlSW5mby5WaXN1YWxEZWJ1Z0ZsYWdzRW50cnlSEHZpc3VhbERlYnVnRmxhZ3MaQwoVVmlzdWFsRGVidWdGbGFnc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgIUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use storyIdInfoDescriptor instead')
const StoryIdInfo$json = const {
  '1': 'StoryIdInfo',
  '2': const [
    const {'1': 'storiesMapKey', '3': 1, '4': 1, '5': 9, '10': 'storiesMapKey'},
    const {'1': 'package', '3': 2, '4': 1, '5': 9, '10': 'package'},
    const {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'storyName', '3': 4, '4': 1, '5': 9, '10': 'storyName'},
  ],
};

/// Descriptor for `StoryIdInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storyIdInfoDescriptor = $convert.base64Decode('CgtTdG9yeUlkSW5mbxIkCg1zdG9yaWVzTWFwS2V5GAEgASgJUg1zdG9yaWVzTWFwS2V5EhgKB3BhY2thZ2UYAiABKAlSB3BhY2thZ2USEgoEcGF0aBgDIAEoCVIEcGF0aBIcCglzdG9yeU5hbWUYBCABKAlSCXN0b3J5TmFtZQ==');
@$core.Deprecated('Use storiesInfoDescriptor instead')
const StoriesInfo$json = const {
  '1': 'StoriesInfo',
  '2': const [
    const {'1': 'package', '3': 1, '4': 1, '5': 9, '10': 'package'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'storiesNames', '3': 3, '4': 3, '5': 9, '10': 'storiesNames'},
  ],
};

/// Descriptor for `StoriesInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storiesInfoDescriptor = $convert.base64Decode('CgtTdG9yaWVzSW5mbxIYCgdwYWNrYWdlGAEgASgJUgdwYWNrYWdlEhIKBHBhdGgYAiABKAlSBHBhdGgSIgoMc3Rvcmllc05hbWVzGAMgAygJUgxzdG9yaWVzTmFtZXM=');
@$core.Deprecated('Use textScaleFactorInfoDescriptor instead')
const TextScaleFactorInfo$json = const {
  '1': 'TextScaleFactorInfo',
  '2': const [
    const {'1': 'scale', '3': 1, '4': 1, '5': 1, '10': 'scale'},
  ],
};

/// Descriptor for `TextScaleFactorInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textScaleFactorInfoDescriptor = $convert.base64Decode('ChNUZXh0U2NhbGVGYWN0b3JJbmZvEhQKBXNjYWxlGAEgASgBUgVzY2FsZQ==');
@$core.Deprecated('Use localeInfoDescriptor instead')
const LocaleInfo$json = const {
  '1': 'LocaleInfo',
  '2': const [
    const {'1': 'languageTag', '3': 1, '4': 1, '5': 9, '10': 'languageTag'},
  ],
};

/// Descriptor for `LocaleInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localeInfoDescriptor = $convert.base64Decode('CgpMb2NhbGVJbmZvEiAKC2xhbmd1YWdlVGFnGAEgASgJUgtsYW5ndWFnZVRhZw==');
@$core.Deprecated('Use localizationInfoDescriptor instead')
const LocalizationInfo$json = const {
  '1': 'LocalizationInfo',
  '2': const [
    const {'1': 'localeLanguageTags', '3': 1, '4': 3, '5': 9, '10': 'localeLanguageTags'},
    const {'1': 'delegateClassName', '3': 2, '4': 1, '5': 9, '10': 'delegateClassName'},
  ],
};

/// Descriptor for `LocalizationInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localizationInfoDescriptor = $convert.base64Decode('ChBMb2NhbGl6YXRpb25JbmZvEi4KEmxvY2FsZUxhbmd1YWdlVGFncxgBIAMoCVISbG9jYWxlTGFuZ3VhZ2VUYWdzEiwKEWRlbGVnYXRlQ2xhc3NOYW1lGAIgASgJUhFkZWxlZ2F0ZUNsYXNzTmFtZQ==');
@$core.Deprecated('Use themeInfoDescriptor instead')
const ThemeInfo$json = const {
  '1': 'ThemeInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'isDefault', '3': 3, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `ThemeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List themeInfoDescriptor = $convert.base64Decode('CglUaGVtZUluZm8SDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHAoJaXNEZWZhdWx0GAMgASgIUglpc0RlZmF1bHQ=');
@$core.Deprecated('Use logicalResolutionInfoDescriptor instead')
const LogicalResolutionInfo$json = const {
  '1': 'LogicalResolutionInfo',
  '2': const [
    const {'1': 'width', '3': 1, '4': 1, '5': 1, '10': 'width'},
    const {'1': 'height', '3': 2, '4': 1, '5': 1, '10': 'height'},
  ],
};

/// Descriptor for `LogicalResolutionInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logicalResolutionInfoDescriptor = $convert.base64Decode('ChVMb2dpY2FsUmVzb2x1dGlvbkluZm8SFAoFd2lkdGgYASABKAFSBXdpZHRoEhYKBmhlaWdodBgCIAEoAVIGaGVpZ2h0');
@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = const {
  '1': 'DeviceInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'targetPlatform', '3': 3, '4': 1, '5': 9, '10': 'targetPlatform'},
    const {'1': 'logicalResolutionInfo', '3': 4, '4': 1, '5': 11, '6': '.monarch_grpc.LogicalResolutionInfo', '10': 'logicalResolutionInfo'},
    const {'1': 'devicePixelRatio', '3': 5, '4': 1, '5': 1, '10': 'devicePixelRatio'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor = $convert.base64Decode('CgpEZXZpY2VJbmZvEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiYKDnRhcmdldFBsYXRmb3JtGAMgASgJUg50YXJnZXRQbGF0Zm9ybRJZChVsb2dpY2FsUmVzb2x1dGlvbkluZm8YBCABKAsyIy5tb25hcmNoX2dycGMuTG9naWNhbFJlc29sdXRpb25JbmZvUhVsb2dpY2FsUmVzb2x1dGlvbkluZm8SKgoQZGV2aWNlUGl4ZWxSYXRpbxgFIAEoAVIQZGV2aWNlUGl4ZWxSYXRpbw==');
@$core.Deprecated('Use scaleInfoDescriptor instead')
const ScaleInfo$json = const {
  '1': 'ScaleInfo',
  '2': const [
    const {'1': 'scale', '3': 1, '4': 1, '5': 1, '10': 'scale'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `ScaleInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scaleInfoDescriptor = $convert.base64Decode('CglTY2FsZUluZm8SFAoFc2NhbGUYASABKAFSBXNjYWxlEhIKBG5hbWUYAiABKAlSBG5hbWU=');
@$core.Deprecated('Use dockInfoDescriptor instead')
const DockInfo$json = const {
  '1': 'DockInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `DockInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dockInfoDescriptor = $convert.base64Decode('CghEb2NrSW5mbxIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZQ==');
@$core.Deprecated('Use visualDebugFlagInfoDescriptor instead')
const VisualDebugFlagInfo$json = const {
  '1': 'VisualDebugFlagInfo',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'isEnabled', '3': 2, '4': 1, '5': 8, '10': 'isEnabled'},
  ],
};

/// Descriptor for `VisualDebugFlagInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List visualDebugFlagInfoDescriptor = $convert.base64Decode('ChNWaXN1YWxEZWJ1Z0ZsYWdJbmZvEhIKBG5hbWUYASABKAlSBG5hbWUSHAoJaXNFbmFibGVkGAIgASgIUglpc0VuYWJsZWQ=');
@$core.Deprecated('Use uriInfoDescriptor instead')
const UriInfo$json = const {
  '1': 'UriInfo',
  '2': const [
    const {'1': 'host', '3': 1, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'port', '3': 2, '4': 1, '5': 5, '10': 'port'},
    const {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'scheme', '3': 4, '4': 1, '5': 9, '10': 'scheme'},
  ],
};

/// Descriptor for `UriInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uriInfoDescriptor = $convert.base64Decode('CgdVcmlJbmZvEhIKBGhvc3QYASABKAlSBGhvc3QSEgoEcG9ydBgCIAEoBVIEcG9ydBISCgRwYXRoGAMgASgJUgRwYXRoEhYKBnNjaGVtZRgEIAEoCVIGc2NoZW1l');
@$core.Deprecated('Use serverInfoDescriptor instead')
const ServerInfo$json = const {
  '1': 'ServerInfo',
  '2': const [
    const {'1': 'port', '3': 1, '4': 1, '5': 5, '10': 'port'},
  ],
};

/// Descriptor for `ServerInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverInfoDescriptor = $convert.base64Decode('CgpTZXJ2ZXJJbmZvEhIKBHBvcnQYASABKAVSBHBvcnQ=');
@$core.Deprecated('Use serverListInfoDescriptor instead')
const ServerListInfo$json = const {
  '1': 'ServerListInfo',
  '2': const [
    const {'1': 'servers', '3': 1, '4': 3, '5': 11, '6': '.monarch_grpc.ServerInfo', '10': 'servers'},
  ],
};

/// Descriptor for `ServerListInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverListInfoDescriptor = $convert.base64Decode('Cg5TZXJ2ZXJMaXN0SW5mbxIyCgdzZXJ2ZXJzGAEgAygLMhgubW9uYXJjaF9ncnBjLlNlcnZlckluZm9SB3NlcnZlcnM=');
@$core.Deprecated('Use reloadResponseDescriptor instead')
const ReloadResponse$json = const {
  '1': 'ReloadResponse',
  '2': const [
    const {'1': 'isSuccessful', '3': 1, '4': 1, '5': 8, '10': 'isSuccessful'},
  ],
};

/// Descriptor for `ReloadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reloadResponseDescriptor = $convert.base64Decode('Cg5SZWxvYWRSZXNwb25zZRIiCgxpc1N1Y2Nlc3NmdWwYASABKAhSDGlzU3VjY2Vzc2Z1bA==');
@$core.Deprecated('Use userMessageInfoDescriptor instead')
const UserMessageInfo$json = const {
  '1': 'UserMessageInfo',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UserMessageInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userMessageInfoDescriptor = $convert.base64Decode('Cg9Vc2VyTWVzc2FnZUluZm8SGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use userSelectionDataDescriptor instead')
const UserSelectionData$json = const {
  '1': 'UserSelectionData',
  '2': const [
    const {'1': 'kind', '3': 1, '4': 1, '5': 9, '10': 'kind'},
    const {'1': 'localeCount', '3': 2, '4': 1, '5': 5, '10': 'localeCount'},
    const {'1': 'userThemeCount', '3': 3, '4': 1, '5': 5, '10': 'userThemeCount'},
    const {'1': 'storyCount', '3': 4, '4': 1, '5': 5, '10': 'storyCount'},
    const {'1': 'selectedDevice', '3': 5, '4': 1, '5': 9, '10': 'selectedDevice'},
    const {'1': 'selectedTextScaleFactor', '3': 6, '4': 1, '5': 1, '10': 'selectedTextScaleFactor'},
    const {'1': 'selectedStoryScale', '3': 7, '4': 1, '5': 1, '10': 'selectedStoryScale'},
    const {'1': 'selectedDockSide', '3': 8, '4': 1, '5': 9, '10': 'selectedDockSide'},
    const {'1': 'slowAnimationsEnabled', '3': 9, '4': 1, '5': 8, '10': 'slowAnimationsEnabled'},
    const {'1': 'showGuidelinesEnabled', '3': 10, '4': 1, '5': 8, '10': 'showGuidelinesEnabled'},
    const {'1': 'showBaselinesEnabled', '3': 11, '4': 1, '5': 8, '10': 'showBaselinesEnabled'},
    const {'1': 'highlightRepaintsEnabled', '3': 12, '4': 1, '5': 8, '10': 'highlightRepaintsEnabled'},
    const {'1': 'highlightOversizedImagesEnabled', '3': 13, '4': 1, '5': 8, '10': 'highlightOversizedImagesEnabled'},
  ],
};

/// Descriptor for `UserSelectionData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSelectionDataDescriptor = $convert.base64Decode('ChFVc2VyU2VsZWN0aW9uRGF0YRISCgRraW5kGAEgASgJUgRraW5kEiAKC2xvY2FsZUNvdW50GAIgASgFUgtsb2NhbGVDb3VudBImCg51c2VyVGhlbWVDb3VudBgDIAEoBVIOdXNlclRoZW1lQ291bnQSHgoKc3RvcnlDb3VudBgEIAEoBVIKc3RvcnlDb3VudBImCg5zZWxlY3RlZERldmljZRgFIAEoCVIOc2VsZWN0ZWREZXZpY2USOAoXc2VsZWN0ZWRUZXh0U2NhbGVGYWN0b3IYBiABKAFSF3NlbGVjdGVkVGV4dFNjYWxlRmFjdG9yEi4KEnNlbGVjdGVkU3RvcnlTY2FsZRgHIAEoAVISc2VsZWN0ZWRTdG9yeVNjYWxlEioKEHNlbGVjdGVkRG9ja1NpZGUYCCABKAlSEHNlbGVjdGVkRG9ja1NpZGUSNAoVc2xvd0FuaW1hdGlvbnNFbmFibGVkGAkgASgIUhVzbG93QW5pbWF0aW9uc0VuYWJsZWQSNAoVc2hvd0d1aWRlbGluZXNFbmFibGVkGAogASgIUhVzaG93R3VpZGVsaW5lc0VuYWJsZWQSMgoUc2hvd0Jhc2VsaW5lc0VuYWJsZWQYCyABKAhSFHNob3dCYXNlbGluZXNFbmFibGVkEjoKGGhpZ2hsaWdodFJlcGFpbnRzRW5hYmxlZBgMIAEoCFIYaGlnaGxpZ2h0UmVwYWludHNFbmFibGVkEkgKH2hpZ2hsaWdodE92ZXJzaXplZEltYWdlc0VuYWJsZWQYDSABKAhSH2hpZ2hsaWdodE92ZXJzaXplZEltYWdlc0VuYWJsZWQ=');
