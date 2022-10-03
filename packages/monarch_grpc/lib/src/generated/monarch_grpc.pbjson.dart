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
@$core.Deprecated('Use reloadResponseDescriptor instead')
const ReloadResponse$json = const {
  '1': 'ReloadResponse',
  '2': const [
    const {'1': 'isSuccessful', '3': 1, '4': 1, '5': 8, '10': 'isSuccessful'},
  ],
};

/// Descriptor for `ReloadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reloadResponseDescriptor = $convert.base64Decode('Cg5SZWxvYWRSZXNwb25zZRIiCgxpc1N1Y2Nlc3NmdWwYASABKAhSDGlzU3VjY2Vzc2Z1bA==');
@$core.Deprecated('Use userMessageDescriptor instead')
const UserMessage$json = const {
  '1': 'UserMessage',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UserMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userMessageDescriptor = $convert.base64Decode('CgtVc2VyTWVzc2FnZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');
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
