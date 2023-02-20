///
//  Generated code. Do not modify.
//  source: monarch_grpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

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

class ReferenceDataInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReferenceDataInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..pc<DeviceInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'devices', $pb.PbFieldType.PM, subBuilder: DeviceInfo.create)
    ..pc<ThemeInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'standardThemes', $pb.PbFieldType.PM, protoName: 'standardThemes', subBuilder: ThemeInfo.create)
    ..pc<ScaleInfo>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scales', $pb.PbFieldType.PM, subBuilder: ScaleInfo.create)
    ..hasRequiredFields = false
  ;

  ReferenceDataInfo._() : super();
  factory ReferenceDataInfo({
    $core.Iterable<DeviceInfo>? devices,
    $core.Iterable<ThemeInfo>? standardThemes,
    $core.Iterable<ScaleInfo>? scales,
  }) {
    final _result = create();
    if (devices != null) {
      _result.devices.addAll(devices);
    }
    if (standardThemes != null) {
      _result.standardThemes.addAll(standardThemes);
    }
    if (scales != null) {
      _result.scales.addAll(scales);
    }
    return _result;
  }
  factory ReferenceDataInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReferenceDataInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReferenceDataInfo clone() => ReferenceDataInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReferenceDataInfo copyWith(void Function(ReferenceDataInfo) updates) => super.copyWith((message) => updates(message as ReferenceDataInfo)) as ReferenceDataInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReferenceDataInfo create() => ReferenceDataInfo._();
  ReferenceDataInfo createEmptyInstance() => create();
  static $pb.PbList<ReferenceDataInfo> createRepeated() => $pb.PbList<ReferenceDataInfo>();
  @$core.pragma('dart2js:noInline')
  static ReferenceDataInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReferenceDataInfo>(create);
  static ReferenceDataInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DeviceInfo> get devices => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<ThemeInfo> get standardThemes => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<ScaleInfo> get scales => $_getList(2);
}

class ProjectDataInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProjectDataInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'packageName', protoName: 'packageName')
    ..m<$core.String, StoriesInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storiesMap', protoName: 'storiesMap', entryClassName: 'ProjectDataInfo.StoriesMapEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: StoriesInfo.create, packageName: const $pb.PackageName('monarch_grpc'))
    ..pc<ThemeInfo>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'themes', $pb.PbFieldType.PM, subBuilder: ThemeInfo.create)
    ..pc<LocalizationInfo>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localizations', $pb.PbFieldType.PM, subBuilder: LocalizationInfo.create)
    ..hasRequiredFields = false
  ;

  ProjectDataInfo._() : super();
  factory ProjectDataInfo({
    $core.String? packageName,
    $core.Map<$core.String, StoriesInfo>? storiesMap,
    $core.Iterable<ThemeInfo>? themes,
    $core.Iterable<LocalizationInfo>? localizations,
  }) {
    final _result = create();
    if (packageName != null) {
      _result.packageName = packageName;
    }
    if (storiesMap != null) {
      _result.storiesMap.addAll(storiesMap);
    }
    if (themes != null) {
      _result.themes.addAll(themes);
    }
    if (localizations != null) {
      _result.localizations.addAll(localizations);
    }
    return _result;
  }
  factory ProjectDataInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProjectDataInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProjectDataInfo clone() => ProjectDataInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProjectDataInfo copyWith(void Function(ProjectDataInfo) updates) => super.copyWith((message) => updates(message as ProjectDataInfo)) as ProjectDataInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProjectDataInfo create() => ProjectDataInfo._();
  ProjectDataInfo createEmptyInstance() => create();
  static $pb.PbList<ProjectDataInfo> createRepeated() => $pb.PbList<ProjectDataInfo>();
  @$core.pragma('dart2js:noInline')
  static ProjectDataInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProjectDataInfo>(create);
  static ProjectDataInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packageName => $_getSZ(0);
  @$pb.TagNumber(1)
  set packageName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPackageName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackageName() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.String, StoriesInfo> get storiesMap => $_getMap(1);

  @$pb.TagNumber(3)
  $core.List<ThemeInfo> get themes => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<LocalizationInfo> get localizations => $_getList(3);
}

class SelectionsStateInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SelectionsStateInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOM<StoryIdInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storyId', protoName: 'storyId', subBuilder: StoryIdInfo.create)
    ..aOM<DeviceInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device', subBuilder: DeviceInfo.create)
    ..aOM<ThemeInfo>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'theme', subBuilder: ThemeInfo.create)
    ..aOM<LocaleInfo>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'locale', subBuilder: LocaleInfo.create)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'textScaleFactor', $pb.PbFieldType.OD, protoName: 'textScaleFactor')
    ..aOM<ScaleInfo>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scale', subBuilder: ScaleInfo.create)
    ..aOM<DockInfo>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dock', subBuilder: DockInfo.create)
    ..m<$core.String, $core.bool>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'visualDebugFlags', protoName: 'visualDebugFlags', entryClassName: 'SelectionsStateInfo.VisualDebugFlagsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OB, packageName: const $pb.PackageName('monarch_grpc'))
    ..hasRequiredFields = false
  ;

  SelectionsStateInfo._() : super();
  factory SelectionsStateInfo({
    StoryIdInfo? storyId,
    DeviceInfo? device,
    ThemeInfo? theme,
    LocaleInfo? locale,
    $core.double? textScaleFactor,
    ScaleInfo? scale,
    DockInfo? dock,
    $core.Map<$core.String, $core.bool>? visualDebugFlags,
  }) {
    final _result = create();
    if (storyId != null) {
      _result.storyId = storyId;
    }
    if (device != null) {
      _result.device = device;
    }
    if (theme != null) {
      _result.theme = theme;
    }
    if (locale != null) {
      _result.locale = locale;
    }
    if (textScaleFactor != null) {
      _result.textScaleFactor = textScaleFactor;
    }
    if (scale != null) {
      _result.scale = scale;
    }
    if (dock != null) {
      _result.dock = dock;
    }
    if (visualDebugFlags != null) {
      _result.visualDebugFlags.addAll(visualDebugFlags);
    }
    return _result;
  }
  factory SelectionsStateInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SelectionsStateInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SelectionsStateInfo clone() => SelectionsStateInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SelectionsStateInfo copyWith(void Function(SelectionsStateInfo) updates) => super.copyWith((message) => updates(message as SelectionsStateInfo)) as SelectionsStateInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SelectionsStateInfo create() => SelectionsStateInfo._();
  SelectionsStateInfo createEmptyInstance() => create();
  static $pb.PbList<SelectionsStateInfo> createRepeated() => $pb.PbList<SelectionsStateInfo>();
  @$core.pragma('dart2js:noInline')
  static SelectionsStateInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectionsStateInfo>(create);
  static SelectionsStateInfo? _defaultInstance;

  @$pb.TagNumber(1)
  StoryIdInfo get storyId => $_getN(0);
  @$pb.TagNumber(1)
  set storyId(StoryIdInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStoryId() => clearField(1);
  @$pb.TagNumber(1)
  StoryIdInfo ensureStoryId() => $_ensure(0);

  @$pb.TagNumber(2)
  DeviceInfo get device => $_getN(1);
  @$pb.TagNumber(2)
  set device(DeviceInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDevice() => $_has(1);
  @$pb.TagNumber(2)
  void clearDevice() => clearField(2);
  @$pb.TagNumber(2)
  DeviceInfo ensureDevice() => $_ensure(1);

  @$pb.TagNumber(3)
  ThemeInfo get theme => $_getN(2);
  @$pb.TagNumber(3)
  set theme(ThemeInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTheme() => $_has(2);
  @$pb.TagNumber(3)
  void clearTheme() => clearField(3);
  @$pb.TagNumber(3)
  ThemeInfo ensureTheme() => $_ensure(2);

  @$pb.TagNumber(4)
  LocaleInfo get locale => $_getN(3);
  @$pb.TagNumber(4)
  set locale(LocaleInfo v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLocale() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocale() => clearField(4);
  @$pb.TagNumber(4)
  LocaleInfo ensureLocale() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get textScaleFactor => $_getN(4);
  @$pb.TagNumber(5)
  set textScaleFactor($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTextScaleFactor() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextScaleFactor() => clearField(5);

  @$pb.TagNumber(6)
  ScaleInfo get scale => $_getN(5);
  @$pb.TagNumber(6)
  set scale(ScaleInfo v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasScale() => $_has(5);
  @$pb.TagNumber(6)
  void clearScale() => clearField(6);
  @$pb.TagNumber(6)
  ScaleInfo ensureScale() => $_ensure(5);

  @$pb.TagNumber(7)
  DockInfo get dock => $_getN(6);
  @$pb.TagNumber(7)
  set dock(DockInfo v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasDock() => $_has(6);
  @$pb.TagNumber(7)
  void clearDock() => clearField(7);
  @$pb.TagNumber(7)
  DockInfo ensureDock() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.Map<$core.String, $core.bool> get visualDebugFlags => $_getMap(7);
}

class StoryIdInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StoryIdInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storiesMapKey', protoName: 'storiesMapKey')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'package')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storyName', protoName: 'storyName')
    ..hasRequiredFields = false
  ;

  StoryIdInfo._() : super();
  factory StoryIdInfo({
    $core.String? storiesMapKey,
    $core.String? package,
    $core.String? path,
    $core.String? storyName,
  }) {
    final _result = create();
    if (storiesMapKey != null) {
      _result.storiesMapKey = storiesMapKey;
    }
    if (package != null) {
      _result.package = package;
    }
    if (path != null) {
      _result.path = path;
    }
    if (storyName != null) {
      _result.storyName = storyName;
    }
    return _result;
  }
  factory StoryIdInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StoryIdInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StoryIdInfo clone() => StoryIdInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StoryIdInfo copyWith(void Function(StoryIdInfo) updates) => super.copyWith((message) => updates(message as StoryIdInfo)) as StoryIdInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StoryIdInfo create() => StoryIdInfo._();
  StoryIdInfo createEmptyInstance() => create();
  static $pb.PbList<StoryIdInfo> createRepeated() => $pb.PbList<StoryIdInfo>();
  @$core.pragma('dart2js:noInline')
  static StoryIdInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoryIdInfo>(create);
  static StoryIdInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get storiesMapKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set storiesMapKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStoriesMapKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearStoriesMapKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get package => $_getSZ(1);
  @$pb.TagNumber(2)
  set package($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPackage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get storyName => $_getSZ(3);
  @$pb.TagNumber(4)
  set storyName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStoryName() => $_has(3);
  @$pb.TagNumber(4)
  void clearStoryName() => clearField(4);
}

class StoriesInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StoriesInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'package')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storiesNames', protoName: 'storiesNames')
    ..hasRequiredFields = false
  ;

  StoriesInfo._() : super();
  factory StoriesInfo({
    $core.String? package,
    $core.String? path,
    $core.Iterable<$core.String>? storiesNames,
  }) {
    final _result = create();
    if (package != null) {
      _result.package = package;
    }
    if (path != null) {
      _result.path = path;
    }
    if (storiesNames != null) {
      _result.storiesNames.addAll(storiesNames);
    }
    return _result;
  }
  factory StoriesInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StoriesInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StoriesInfo clone() => StoriesInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StoriesInfo copyWith(void Function(StoriesInfo) updates) => super.copyWith((message) => updates(message as StoriesInfo)) as StoriesInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StoriesInfo create() => StoriesInfo._();
  StoriesInfo createEmptyInstance() => create();
  static $pb.PbList<StoriesInfo> createRepeated() => $pb.PbList<StoriesInfo>();
  @$core.pragma('dart2js:noInline')
  static StoriesInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoriesInfo>(create);
  static StoriesInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get package => $_getSZ(0);
  @$pb.TagNumber(1)
  set package($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPackage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get storiesNames => $_getList(2);
}

class TextScaleFactorInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TextScaleFactorInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scale', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  TextScaleFactorInfo._() : super();
  factory TextScaleFactorInfo({
    $core.double? scale,
  }) {
    final _result = create();
    if (scale != null) {
      _result.scale = scale;
    }
    return _result;
  }
  factory TextScaleFactorInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TextScaleFactorInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TextScaleFactorInfo clone() => TextScaleFactorInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TextScaleFactorInfo copyWith(void Function(TextScaleFactorInfo) updates) => super.copyWith((message) => updates(message as TextScaleFactorInfo)) as TextScaleFactorInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TextScaleFactorInfo create() => TextScaleFactorInfo._();
  TextScaleFactorInfo createEmptyInstance() => create();
  static $pb.PbList<TextScaleFactorInfo> createRepeated() => $pb.PbList<TextScaleFactorInfo>();
  @$core.pragma('dart2js:noInline')
  static TextScaleFactorInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextScaleFactorInfo>(create);
  static TextScaleFactorInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get scale => $_getN(0);
  @$pb.TagNumber(1)
  set scale($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasScale() => $_has(0);
  @$pb.TagNumber(1)
  void clearScale() => clearField(1);
}

class LocaleInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocaleInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'languageTag', protoName: 'languageTag')
    ..hasRequiredFields = false
  ;

  LocaleInfo._() : super();
  factory LocaleInfo({
    $core.String? languageTag,
  }) {
    final _result = create();
    if (languageTag != null) {
      _result.languageTag = languageTag;
    }
    return _result;
  }
  factory LocaleInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocaleInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocaleInfo clone() => LocaleInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocaleInfo copyWith(void Function(LocaleInfo) updates) => super.copyWith((message) => updates(message as LocaleInfo)) as LocaleInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocaleInfo create() => LocaleInfo._();
  LocaleInfo createEmptyInstance() => create();
  static $pb.PbList<LocaleInfo> createRepeated() => $pb.PbList<LocaleInfo>();
  @$core.pragma('dart2js:noInline')
  static LocaleInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocaleInfo>(create);
  static LocaleInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get languageTag => $_getSZ(0);
  @$pb.TagNumber(1)
  set languageTag($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLanguageTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguageTag() => clearField(1);
}

class LocalizationInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalizationInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localeLanguageTags', protoName: 'localeLanguageTags')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'delegateClassName', protoName: 'delegateClassName')
    ..hasRequiredFields = false
  ;

  LocalizationInfo._() : super();
  factory LocalizationInfo({
    $core.Iterable<$core.String>? localeLanguageTags,
    $core.String? delegateClassName,
  }) {
    final _result = create();
    if (localeLanguageTags != null) {
      _result.localeLanguageTags.addAll(localeLanguageTags);
    }
    if (delegateClassName != null) {
      _result.delegateClassName = delegateClassName;
    }
    return _result;
  }
  factory LocalizationInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalizationInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalizationInfo clone() => LocalizationInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalizationInfo copyWith(void Function(LocalizationInfo) updates) => super.copyWith((message) => updates(message as LocalizationInfo)) as LocalizationInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalizationInfo create() => LocalizationInfo._();
  LocalizationInfo createEmptyInstance() => create();
  static $pb.PbList<LocalizationInfo> createRepeated() => $pb.PbList<LocalizationInfo>();
  @$core.pragma('dart2js:noInline')
  static LocalizationInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalizationInfo>(create);
  static LocalizationInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get localeLanguageTags => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get delegateClassName => $_getSZ(1);
  @$pb.TagNumber(2)
  set delegateClassName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDelegateClassName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelegateClassName() => clearField(2);
}

class ThemeInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ThemeInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isDefault', protoName: 'isDefault')
    ..hasRequiredFields = false
  ;

  ThemeInfo._() : super();
  factory ThemeInfo({
    $core.String? id,
    $core.String? name,
    $core.bool? isDefault,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (isDefault != null) {
      _result.isDefault = isDefault;
    }
    return _result;
  }
  factory ThemeInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ThemeInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ThemeInfo clone() => ThemeInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ThemeInfo copyWith(void Function(ThemeInfo) updates) => super.copyWith((message) => updates(message as ThemeInfo)) as ThemeInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ThemeInfo create() => ThemeInfo._();
  ThemeInfo createEmptyInstance() => create();
  static $pb.PbList<ThemeInfo> createRepeated() => $pb.PbList<ThemeInfo>();
  @$core.pragma('dart2js:noInline')
  static ThemeInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ThemeInfo>(create);
  static ThemeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isDefault => $_getBF(2);
  @$pb.TagNumber(3)
  set isDefault($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsDefault() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsDefault() => clearField(3);
}

class LogicalResolutionInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LogicalResolutionInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'width', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  LogicalResolutionInfo._() : super();
  factory LogicalResolutionInfo({
    $core.double? width,
    $core.double? height,
  }) {
    final _result = create();
    if (width != null) {
      _result.width = width;
    }
    if (height != null) {
      _result.height = height;
    }
    return _result;
  }
  factory LogicalResolutionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LogicalResolutionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LogicalResolutionInfo clone() => LogicalResolutionInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LogicalResolutionInfo copyWith(void Function(LogicalResolutionInfo) updates) => super.copyWith((message) => updates(message as LogicalResolutionInfo)) as LogicalResolutionInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LogicalResolutionInfo create() => LogicalResolutionInfo._();
  LogicalResolutionInfo createEmptyInstance() => create();
  static $pb.PbList<LogicalResolutionInfo> createRepeated() => $pb.PbList<LogicalResolutionInfo>();
  @$core.pragma('dart2js:noInline')
  static LogicalResolutionInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogicalResolutionInfo>(create);
  static LogicalResolutionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get height => $_getN(1);
  @$pb.TagNumber(2)
  set height($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => clearField(2);
}

class DeviceInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeviceInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetPlatform', protoName: 'targetPlatform')
    ..aOM<LogicalResolutionInfo>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'logicalResolutionInfo', protoName: 'logicalResolutionInfo', subBuilder: LogicalResolutionInfo.create)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'devicePixelRatio', $pb.PbFieldType.OD, protoName: 'devicePixelRatio')
    ..hasRequiredFields = false
  ;

  DeviceInfo._() : super();
  factory DeviceInfo({
    $core.String? id,
    $core.String? name,
    $core.String? targetPlatform,
    LogicalResolutionInfo? logicalResolutionInfo,
    $core.double? devicePixelRatio,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (targetPlatform != null) {
      _result.targetPlatform = targetPlatform;
    }
    if (logicalResolutionInfo != null) {
      _result.logicalResolutionInfo = logicalResolutionInfo;
    }
    if (devicePixelRatio != null) {
      _result.devicePixelRatio = devicePixelRatio;
    }
    return _result;
  }
  factory DeviceInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceInfo clone() => DeviceInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) => super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetPlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetPlatform($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTargetPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetPlatform() => clearField(3);

  @$pb.TagNumber(4)
  LogicalResolutionInfo get logicalResolutionInfo => $_getN(3);
  @$pb.TagNumber(4)
  set logicalResolutionInfo(LogicalResolutionInfo v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLogicalResolutionInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearLogicalResolutionInfo() => clearField(4);
  @$pb.TagNumber(4)
  LogicalResolutionInfo ensureLogicalResolutionInfo() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get devicePixelRatio => $_getN(4);
  @$pb.TagNumber(5)
  set devicePixelRatio($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDevicePixelRatio() => $_has(4);
  @$pb.TagNumber(5)
  void clearDevicePixelRatio() => clearField(5);
}

class ScaleInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScaleInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scale', $pb.PbFieldType.OD)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  ScaleInfo._() : super();
  factory ScaleInfo({
    $core.double? scale,
    $core.String? name,
  }) {
    final _result = create();
    if (scale != null) {
      _result.scale = scale;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory ScaleInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScaleInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScaleInfo clone() => ScaleInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScaleInfo copyWith(void Function(ScaleInfo) updates) => super.copyWith((message) => updates(message as ScaleInfo)) as ScaleInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScaleInfo create() => ScaleInfo._();
  ScaleInfo createEmptyInstance() => create();
  static $pb.PbList<ScaleInfo> createRepeated() => $pb.PbList<ScaleInfo>();
  @$core.pragma('dart2js:noInline')
  static ScaleInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScaleInfo>(create);
  static ScaleInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get scale => $_getN(0);
  @$pb.TagNumber(1)
  set scale($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasScale() => $_has(0);
  @$pb.TagNumber(1)
  void clearScale() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class DockInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DockInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  DockInfo._() : super();
  factory DockInfo({
    $core.String? id,
    $core.String? name,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory DockInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DockInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DockInfo clone() => DockInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DockInfo copyWith(void Function(DockInfo) updates) => super.copyWith((message) => updates(message as DockInfo)) as DockInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DockInfo create() => DockInfo._();
  DockInfo createEmptyInstance() => create();
  static $pb.PbList<DockInfo> createRepeated() => $pb.PbList<DockInfo>();
  @$core.pragma('dart2js:noInline')
  static DockInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DockInfo>(create);
  static DockInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class VisualDebugFlagInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VisualDebugFlagInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isEnabled', protoName: 'isEnabled')
    ..hasRequiredFields = false
  ;

  VisualDebugFlagInfo._() : super();
  factory VisualDebugFlagInfo({
    $core.String? name,
    $core.bool? isEnabled,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (isEnabled != null) {
      _result.isEnabled = isEnabled;
    }
    return _result;
  }
  factory VisualDebugFlagInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VisualDebugFlagInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VisualDebugFlagInfo clone() => VisualDebugFlagInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VisualDebugFlagInfo copyWith(void Function(VisualDebugFlagInfo) updates) => super.copyWith((message) => updates(message as VisualDebugFlagInfo)) as VisualDebugFlagInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VisualDebugFlagInfo create() => VisualDebugFlagInfo._();
  VisualDebugFlagInfo createEmptyInstance() => create();
  static $pb.PbList<VisualDebugFlagInfo> createRepeated() => $pb.PbList<VisualDebugFlagInfo>();
  @$core.pragma('dart2js:noInline')
  static VisualDebugFlagInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VisualDebugFlagInfo>(create);
  static VisualDebugFlagInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set isEnabled($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsEnabled() => clearField(2);
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

class ServerListInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServerListInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..pc<ServerInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'servers', $pb.PbFieldType.PM, subBuilder: ServerInfo.create)
    ..hasRequiredFields = false
  ;

  ServerListInfo._() : super();
  factory ServerListInfo({
    $core.Iterable<ServerInfo>? servers,
  }) {
    final _result = create();
    if (servers != null) {
      _result.servers.addAll(servers);
    }
    return _result;
  }
  factory ServerListInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerListInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerListInfo clone() => ServerListInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerListInfo copyWith(void Function(ServerListInfo) updates) => super.copyWith((message) => updates(message as ServerListInfo)) as ServerListInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServerListInfo create() => ServerListInfo._();
  ServerListInfo createEmptyInstance() => create();
  static $pb.PbList<ServerListInfo> createRepeated() => $pb.PbList<ServerListInfo>();
  @$core.pragma('dart2js:noInline')
  static ServerListInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerListInfo>(create);
  static ServerListInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ServerInfo> get servers => $_getList(0);
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

class UserMessageInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserMessageInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  UserMessageInfo._() : super();
  factory UserMessageInfo({
    $core.String? message,
  }) {
    final _result = create();
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory UserMessageInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserMessageInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserMessageInfo clone() => UserMessageInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserMessageInfo copyWith(void Function(UserMessageInfo) updates) => super.copyWith((message) => updates(message as UserMessageInfo)) as UserMessageInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserMessageInfo create() => UserMessageInfo._();
  UserMessageInfo createEmptyInstance() => create();
  static $pb.PbList<UserMessageInfo> createRepeated() => $pb.PbList<UserMessageInfo>();
  @$core.pragma('dart2js:noInline')
  static UserMessageInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserMessageInfo>(create);
  static UserMessageInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

class KindInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'KindInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'monarch_grpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kind')
    ..hasRequiredFields = false
  ;

  KindInfo._() : super();
  factory KindInfo({
    $core.String? kind,
  }) {
    final _result = create();
    if (kind != null) {
      _result.kind = kind;
    }
    return _result;
  }
  factory KindInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KindInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KindInfo clone() => KindInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KindInfo copyWith(void Function(KindInfo) updates) => super.copyWith((message) => updates(message as KindInfo)) as KindInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KindInfo create() => KindInfo._();
  KindInfo createEmptyInstance() => create();
  static $pb.PbList<KindInfo> createRepeated() => $pb.PbList<KindInfo>();
  @$core.pragma('dart2js:noInline')
  static KindInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KindInfo>(create);
  static KindInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => clearField(1);
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

