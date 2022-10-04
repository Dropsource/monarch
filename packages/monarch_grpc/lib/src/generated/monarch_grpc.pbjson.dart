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
@$core.Deprecated('Use referenceDefinitionsDescriptor instead')
const ReferenceDefinitions$json = const {
  '1': 'ReferenceDefinitions',
  '2': const [
    const {'1': 'devices', '3': 1, '4': 3, '5': 11, '6': '.monarch_grpc.DeviceInfo', '10': 'devices'},
    const {'1': 'standardThemes', '3': 2, '4': 3, '5': 11, '6': '.monarch_grpc.ThemeInfo', '10': 'standardThemes'},
    const {'1': 'scales', '3': 3, '4': 3, '5': 11, '6': '.monarch_grpc.ScaleInfo', '10': 'scales'},
  ],
};

/// Descriptor for `ReferenceDefinitions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List referenceDefinitionsDescriptor = $convert.base64Decode('ChRSZWZlcmVuY2VEZWZpbml0aW9ucxIyCgdkZXZpY2VzGAEgAygLMhgubW9uYXJjaF9ncnBjLkRldmljZUluZm9SB2RldmljZXMSPwoOc3RhbmRhcmRUaGVtZXMYAiADKAsyFy5tb25hcmNoX2dycGMuVGhlbWVJbmZvUg5zdGFuZGFyZFRoZW1lcxIvCgZzY2FsZXMYAyADKAsyFy5tb25hcmNoX2dycGMuU2NhbGVJbmZvUgZzY2FsZXM=');
@$core.Deprecated('Use storyKeyInfoDescriptor instead')
const StoryKeyInfo$json = const {
  '1': 'StoryKeyInfo',
  '2': const [
    const {'1': 'storyKey', '3': 1, '4': 1, '5': 9, '10': 'storyKey'},
  ],
};

/// Descriptor for `StoryKeyInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storyKeyInfoDescriptor = $convert.base64Decode('CgxTdG9yeUtleUluZm8SGgoIc3RvcnlLZXkYASABKAlSCHN0b3J5S2V5');
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
@$core.Deprecated('Use storiesMapInfoDescriptor instead')
const StoriesMapInfo$json = const {
  '1': 'StoriesMapInfo',
  '2': const [
    const {'1': 'storiesMap', '3': 1, '4': 3, '5': 11, '6': '.monarch_grpc.StoriesMapInfo.StoriesMapEntry', '10': 'storiesMap'},
  ],
  '3': const [StoriesMapInfo_StoriesMapEntry$json],
};

@$core.Deprecated('Use storiesMapInfoDescriptor instead')
const StoriesMapInfo_StoriesMapEntry$json = const {
  '1': 'StoriesMapEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.monarch_grpc.StoriesInfo', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `StoriesMapInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storiesMapInfoDescriptor = $convert.base64Decode('Cg5TdG9yaWVzTWFwSW5mbxJMCgpzdG9yaWVzTWFwGAEgAygLMiwubW9uYXJjaF9ncnBjLlN0b3JpZXNNYXBJbmZvLlN0b3JpZXNNYXBFbnRyeVIKc3Rvcmllc01hcBpYCg9TdG9yaWVzTWFwRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSLwoFdmFsdWUYAiABKAsyGS5tb25hcmNoX2dycGMuU3Rvcmllc0luZm9SBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use packageInfoDescriptor instead')
const PackageInfo$json = const {
  '1': 'PackageInfo',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `PackageInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageInfoDescriptor = $convert.base64Decode('CgtQYWNrYWdlSW5mbxISCgRuYW1lGAEgASgJUgRuYW1l');
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
@$core.Deprecated('Use localeListInfoDescriptor instead')
const LocaleListInfo$json = const {
  '1': 'LocaleListInfo',
  '2': const [
    const {'1': 'locales', '3': 1, '4': 3, '5': 11, '6': '.monarch_grpc.LocaleInfo', '10': 'locales'},
  ],
};

/// Descriptor for `LocaleListInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localeListInfoDescriptor = $convert.base64Decode('Cg5Mb2NhbGVMaXN0SW5mbxIyCgdsb2NhbGVzGAEgAygLMhgubW9uYXJjaF9ncnBjLkxvY2FsZUluZm9SB2xvY2FsZXM=');
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
@$core.Deprecated('Use themeListInfoDescriptor instead')
const ThemeListInfo$json = const {
  '1': 'ThemeListInfo',
  '2': const [
    const {'1': 'themes', '3': 1, '4': 3, '5': 11, '6': '.monarch_grpc.ThemeInfo', '10': 'themes'},
  ],
};

/// Descriptor for `ThemeListInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List themeListInfoDescriptor = $convert.base64Decode('Cg1UaGVtZUxpc3RJbmZvEi8KBnRoZW1lcxgBIAMoCzIXLm1vbmFyY2hfZ3JwYy5UaGVtZUluZm9SBnRoZW1lcw==');
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
@$core.Deprecated('Use dockSideInfoDescriptor instead')
const DockSideInfo$json = const {
  '1': 'DockSideInfo',
  '2': const [
    const {'1': 'dock', '3': 1, '4': 1, '5': 9, '10': 'dock'},
  ],
};

/// Descriptor for `DockSideInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dockSideInfoDescriptor = $convert.base64Decode('CgxEb2NrU2lkZUluZm8SEgoEZG9jaxgBIAEoCVIEZG9jaw==');
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
