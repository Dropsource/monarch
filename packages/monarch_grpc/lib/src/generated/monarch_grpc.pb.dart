///
//  Generated code. Do not modify.
//  source: monarch_grpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Empty', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Empty._() : super();
  factory Empty() => create();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class UriInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UriInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scheme')
    ..hasRequiredFields = false
  ;

  UriInfo._() : super();
  factory UriInfo({
    $core.String? host,
    $core.int? port,
    $core.String? path,
    $core.String? scheme,
  }) {
    final _result = create();
    if (host != null) {
      _result.host = host;
    }
    if (port != null) {
      _result.port = port;
    }
    if (path != null) {
      _result.path = path;
    }
    if (scheme != null) {
      _result.scheme = scheme;
    }
    return _result;
  }
  factory UriInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UriInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UriInfo clone() => UriInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UriInfo copyWith(void Function(UriInfo) updates) => super.copyWith((message) => updates(message as UriInfo)) as UriInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UriInfo create() => UriInfo._();
  UriInfo createEmptyInstance() => create();
  static $pb.PbList<UriInfo> createRepeated() => $pb.PbList<UriInfo>();
  @$core.pragma('dart2js:noInline')
  static UriInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UriInfo>(create);
  static UriInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get host => $_getSZ(0);
  @$pb.TagNumber(1)
  set host($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHost() => $_has(0);
  @$pb.TagNumber(1)
  void clearHost() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get scheme => $_getSZ(3);
  @$pb.TagNumber(4)
  set scheme($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasScheme() => $_has(3);
  @$pb.TagNumber(4)
  void clearScheme() => clearField(4);
}

class ServerInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServerInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'port', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ServerInfo._() : super();
  factory ServerInfo({
    $core.int? port,
  }) {
    final _result = create();
    if (port != null) {
      _result.port = port;
    }
    return _result;
  }
  factory ServerInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerInfo clone() => ServerInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerInfo copyWith(void Function(ServerInfo) updates) => super.copyWith((message) => updates(message as ServerInfo)) as ServerInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServerInfo create() => ServerInfo._();
  ServerInfo createEmptyInstance() => create();
  static $pb.PbList<ServerInfo> createRepeated() => $pb.PbList<ServerInfo>();
  @$core.pragma('dart2js:noInline')
  static ServerInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerInfo>(create);
  static ServerInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get port => $_getIZ(0);
  @$pb.TagNumber(1)
  set port($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPort() => $_has(0);
  @$pb.TagNumber(1)
  void clearPort() => clearField(1);
}

class ReloadResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReloadResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isSuccessful', protoName: 'isSuccessful')
    ..hasRequiredFields = false
  ;

  ReloadResponse._() : super();
  factory ReloadResponse({
    $core.bool? isSuccessful,
  }) {
    final _result = create();
    if (isSuccessful != null) {
      _result.isSuccessful = isSuccessful;
    }
    return _result;
  }
  factory ReloadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReloadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReloadResponse clone() => ReloadResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReloadResponse copyWith(void Function(ReloadResponse) updates) => super.copyWith((message) => updates(message as ReloadResponse)) as ReloadResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReloadResponse create() => ReloadResponse._();
  ReloadResponse createEmptyInstance() => create();
  static $pb.PbList<ReloadResponse> createRepeated() => $pb.PbList<ReloadResponse>();
  @$core.pragma('dart2js:noInline')
  static ReloadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReloadResponse>(create);
  static ReloadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isSuccessful => $_getBF(0);
  @$pb.TagNumber(1)
  set isSuccessful($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsSuccessful() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsSuccessful() => clearField(1);
}

class UserMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  UserMessage._() : super();
  factory UserMessage({
    $core.String? message,
  }) {
    final _result = create();
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory UserMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserMessage clone() => UserMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserMessage copyWith(void Function(UserMessage) updates) => super.copyWith((message) => updates(message as UserMessage)) as UserMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserMessage create() => UserMessage._();
  UserMessage createEmptyInstance() => create();
  static $pb.PbList<UserMessage> createRepeated() => $pb.PbList<UserMessage>();
  @$core.pragma('dart2js:noInline')
  static UserMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserMessage>(create);
  static UserMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

class UserSelectionData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserSelectionData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kind')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localeCount', $pb.PbFieldType.O3, protoName: 'localeCount')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userThemeCount', $pb.PbFieldType.O3, protoName: 'userThemeCount')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storyCount', $pb.PbFieldType.O3, protoName: 'storyCount')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectedDevice', protoName: 'selectedDevice')
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectedTextScaleFactor', $pb.PbFieldType.OD, protoName: 'selectedTextScaleFactor')
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectedStoryScale', $pb.PbFieldType.OD, protoName: 'selectedStoryScale')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectedDockSide', protoName: 'selectedDockSide')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slowAnimationsEnabled', protoName: 'slowAnimationsEnabled')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showGuidelinesEnabled', protoName: 'showGuidelinesEnabled')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showBaselinesEnabled', protoName: 'showBaselinesEnabled')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'highlightRepaintsEnabled', protoName: 'highlightRepaintsEnabled')
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'highlightOversizedImagesEnabled', protoName: 'highlightOversizedImagesEnabled')
    ..hasRequiredFields = false
  ;

  UserSelectionData._() : super();
  factory UserSelectionData({
    $core.String? kind,
    $core.int? localeCount,
    $core.int? userThemeCount,
    $core.int? storyCount,
    $core.String? selectedDevice,
    $core.double? selectedTextScaleFactor,
    $core.double? selectedStoryScale,
    $core.String? selectedDockSide,
    $core.bool? slowAnimationsEnabled,
    $core.bool? showGuidelinesEnabled,
    $core.bool? showBaselinesEnabled,
    $core.bool? highlightRepaintsEnabled,
    $core.bool? highlightOversizedImagesEnabled,
  }) {
    final _result = create();
    if (kind != null) {
      _result.kind = kind;
    }
    if (localeCount != null) {
      _result.localeCount = localeCount;
    }
    if (userThemeCount != null) {
      _result.userThemeCount = userThemeCount;
    }
    if (storyCount != null) {
      _result.storyCount = storyCount;
    }
    if (selectedDevice != null) {
      _result.selectedDevice = selectedDevice;
    }
    if (selectedTextScaleFactor != null) {
      _result.selectedTextScaleFactor = selectedTextScaleFactor;
    }
    if (selectedStoryScale != null) {
      _result.selectedStoryScale = selectedStoryScale;
    }
    if (selectedDockSide != null) {
      _result.selectedDockSide = selectedDockSide;
    }
    if (slowAnimationsEnabled != null) {
      _result.slowAnimationsEnabled = slowAnimationsEnabled;
    }
    if (showGuidelinesEnabled != null) {
      _result.showGuidelinesEnabled = showGuidelinesEnabled;
    }
    if (showBaselinesEnabled != null) {
      _result.showBaselinesEnabled = showBaselinesEnabled;
    }
    if (highlightRepaintsEnabled != null) {
      _result.highlightRepaintsEnabled = highlightRepaintsEnabled;
    }
    if (highlightOversizedImagesEnabled != null) {
      _result.highlightOversizedImagesEnabled = highlightOversizedImagesEnabled;
    }
    return _result;
  }
  factory UserSelectionData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserSelectionData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserSelectionData clone() => UserSelectionData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserSelectionData copyWith(void Function(UserSelectionData) updates) => super.copyWith((message) => updates(message as UserSelectionData)) as UserSelectionData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserSelectionData create() => UserSelectionData._();
  UserSelectionData createEmptyInstance() => create();
  static $pb.PbList<UserSelectionData> createRepeated() => $pb.PbList<UserSelectionData>();
  @$core.pragma('dart2js:noInline')
  static UserSelectionData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserSelectionData>(create);
  static UserSelectionData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get localeCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set localeCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocaleCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocaleCount() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get userThemeCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set userThemeCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserThemeCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserThemeCount() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get storyCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set storyCount($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStoryCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearStoryCount() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get selectedDevice => $_getSZ(4);
  @$pb.TagNumber(5)
  set selectedDevice($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSelectedDevice() => $_has(4);
  @$pb.TagNumber(5)
  void clearSelectedDevice() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get selectedTextScaleFactor => $_getN(5);
  @$pb.TagNumber(6)
  set selectedTextScaleFactor($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSelectedTextScaleFactor() => $_has(5);
  @$pb.TagNumber(6)
  void clearSelectedTextScaleFactor() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get selectedStoryScale => $_getN(6);
  @$pb.TagNumber(7)
  set selectedStoryScale($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSelectedStoryScale() => $_has(6);
  @$pb.TagNumber(7)
  void clearSelectedStoryScale() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get selectedDockSide => $_getSZ(7);
  @$pb.TagNumber(8)
  set selectedDockSide($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSelectedDockSide() => $_has(7);
  @$pb.TagNumber(8)
  void clearSelectedDockSide() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get slowAnimationsEnabled => $_getBF(8);
  @$pb.TagNumber(9)
  set slowAnimationsEnabled($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSlowAnimationsEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearSlowAnimationsEnabled() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get showGuidelinesEnabled => $_getBF(9);
  @$pb.TagNumber(10)
  set showGuidelinesEnabled($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasShowGuidelinesEnabled() => $_has(9);
  @$pb.TagNumber(10)
  void clearShowGuidelinesEnabled() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get showBaselinesEnabled => $_getBF(10);
  @$pb.TagNumber(11)
  set showBaselinesEnabled($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasShowBaselinesEnabled() => $_has(10);
  @$pb.TagNumber(11)
  void clearShowBaselinesEnabled() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get highlightRepaintsEnabled => $_getBF(11);
  @$pb.TagNumber(12)
  set highlightRepaintsEnabled($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasHighlightRepaintsEnabled() => $_has(11);
  @$pb.TagNumber(12)
  void clearHighlightRepaintsEnabled() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get highlightOversizedImagesEnabled => $_getBF(12);
  @$pb.TagNumber(13)
  set highlightOversizedImagesEnabled($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasHighlightOversizedImagesEnabled() => $_has(12);
  @$pb.TagNumber(13)
  void clearHighlightOversizedImagesEnabled() => clearField(13);
}

