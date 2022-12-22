///
//  Generated code. Do not modify.
//  source: monarch_grpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'monarch_grpc.pb.dart' as $0;
export 'monarch_grpc.pb.dart';

class MonarchPreviewApiClient extends $grpc.Client {
  static final _$getReferenceData =
      $grpc.ClientMethod<$0.Empty, $0.ReferenceDataInfo>(
          '/monarch_grpc.MonarchPreviewApi/GetReferenceData',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ReferenceDataInfo.fromBuffer(value));
  static final _$getProjectData =
      $grpc.ClientMethod<$0.Empty, $0.ProjectDataInfo>(
          '/monarch_grpc.MonarchPreviewApi/GetProjectData',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ProjectDataInfo.fromBuffer(value));
  static final _$getSelectionsState =
      $grpc.ClientMethod<$0.Empty, $0.SelectionsStateInfo>(
          '/monarch_grpc.MonarchPreviewApi/GetSelectionsState',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.SelectionsStateInfo.fromBuffer(value));
  static final _$setStory = $grpc.ClientMethod<$0.StoryIdInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/SetStory',
      ($0.StoryIdInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$resetStory = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/ResetStory',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$setTextScaleFactor =
      $grpc.ClientMethod<$0.TextScaleFactorInfo, $0.Empty>(
          '/monarch_grpc.MonarchPreviewApi/SetTextScaleFactor',
          ($0.TextScaleFactorInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$setLocale = $grpc.ClientMethod<$0.LocaleInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/SetLocale',
      ($0.LocaleInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$setTheme = $grpc.ClientMethod<$0.ThemeInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/SetTheme',
      ($0.ThemeInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$setDevice = $grpc.ClientMethod<$0.DeviceInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/SetDevice',
      ($0.DeviceInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$setScale = $grpc.ClientMethod<$0.ScaleInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/SetScale',
      ($0.ScaleInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$setDock = $grpc.ClientMethod<$0.DockInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/SetDock',
      ($0.DockInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$toggleVisualDebugFlag =
      $grpc.ClientMethod<$0.VisualDebugFlagInfo, $0.Empty>(
          '/monarch_grpc.MonarchPreviewApi/ToggleVisualDebugFlag',
          ($0.VisualDebugFlagInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$hotReload = $grpc.ClientMethod<$0.Empty, $0.ReloadResponse>(
      '/monarch_grpc.MonarchPreviewApi/HotReload',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ReloadResponse.fromBuffer(value));
  static final _$restartPreview = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/RestartPreview',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$launchDevTools = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/LaunchDevTools',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$trackUserSelection = $grpc.ClientMethod<$0.KindInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/TrackUserSelection',
      ($0.KindInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$terminatePreview = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchPreviewApi/TerminatePreview',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  MonarchPreviewApiClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.ReferenceDataInfo> getReferenceData($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getReferenceData, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProjectDataInfo> getProjectData($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getProjectData, request, options: options);
  }

  $grpc.ResponseFuture<$0.SelectionsStateInfo> getSelectionsState(
      $0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSelectionsState, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setStory($0.StoryIdInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setStory, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> resetStory($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resetStory, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setTextScaleFactor(
      $0.TextScaleFactorInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setTextScaleFactor, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setLocale($0.LocaleInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setLocale, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setTheme($0.ThemeInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setTheme, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setDevice($0.DeviceInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setScale($0.ScaleInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setScale, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setDock($0.DockInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setDock, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> toggleVisualDebugFlag(
      $0.VisualDebugFlagInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$toggleVisualDebugFlag, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReloadResponse> hotReload($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$hotReload, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> restartPreview($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restartPreview, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> launchDevTools($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$launchDevTools, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> trackUserSelection($0.KindInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$trackUserSelection, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> terminatePreview($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$terminatePreview, request, options: options);
  }
}

abstract class MonarchPreviewApiServiceBase extends $grpc.Service {
  $core.String get $name => 'monarch_grpc.MonarchPreviewApi';

  MonarchPreviewApiServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ReferenceDataInfo>(
        'GetReferenceData',
        getReferenceData_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ReferenceDataInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ProjectDataInfo>(
        'GetProjectData',
        getProjectData_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ProjectDataInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.SelectionsStateInfo>(
        'GetSelectionsState',
        getSelectionsState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.SelectionsStateInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoryIdInfo, $0.Empty>(
        'SetStory',
        setStory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StoryIdInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'ResetStory',
        resetStory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TextScaleFactorInfo, $0.Empty>(
        'SetTextScaleFactor',
        setTextScaleFactor_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TextScaleFactorInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LocaleInfo, $0.Empty>(
        'SetLocale',
        setLocale_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LocaleInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThemeInfo, $0.Empty>(
        'SetTheme',
        setTheme_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ThemeInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeviceInfo, $0.Empty>(
        'SetDevice',
        setDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeviceInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScaleInfo, $0.Empty>(
        'SetScale',
        setScale_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ScaleInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DockInfo, $0.Empty>(
        'SetDock',
        setDock_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DockInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VisualDebugFlagInfo, $0.Empty>(
        'ToggleVisualDebugFlag',
        toggleVisualDebugFlag_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VisualDebugFlagInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ReloadResponse>(
        'HotReload',
        hotReload_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ReloadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'RestartPreview',
        restartPreview_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'LaunchDevTools',
        launchDevTools_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KindInfo, $0.Empty>(
        'TrackUserSelection',
        trackUserSelection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.KindInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'TerminatePreview',
        terminatePreview_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.ReferenceDataInfo> getReferenceData_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getReferenceData(call, await request);
  }

  $async.Future<$0.ProjectDataInfo> getProjectData_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getProjectData(call, await request);
  }

  $async.Future<$0.SelectionsStateInfo> getSelectionsState_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getSelectionsState(call, await request);
  }

  $async.Future<$0.Empty> setStory_Pre(
      $grpc.ServiceCall call, $async.Future<$0.StoryIdInfo> request) async {
    return setStory(call, await request);
  }

  $async.Future<$0.Empty> resetStory_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return resetStory(call, await request);
  }

  $async.Future<$0.Empty> setTextScaleFactor_Pre($grpc.ServiceCall call,
      $async.Future<$0.TextScaleFactorInfo> request) async {
    return setTextScaleFactor(call, await request);
  }

  $async.Future<$0.Empty> setLocale_Pre(
      $grpc.ServiceCall call, $async.Future<$0.LocaleInfo> request) async {
    return setLocale(call, await request);
  }

  $async.Future<$0.Empty> setTheme_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ThemeInfo> request) async {
    return setTheme(call, await request);
  }

  $async.Future<$0.Empty> setDevice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.DeviceInfo> request) async {
    return setDevice(call, await request);
  }

  $async.Future<$0.Empty> setScale_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ScaleInfo> request) async {
    return setScale(call, await request);
  }

  $async.Future<$0.Empty> setDock_Pre(
      $grpc.ServiceCall call, $async.Future<$0.DockInfo> request) async {
    return setDock(call, await request);
  }

  $async.Future<$0.Empty> toggleVisualDebugFlag_Pre($grpc.ServiceCall call,
      $async.Future<$0.VisualDebugFlagInfo> request) async {
    return toggleVisualDebugFlag(call, await request);
  }

  $async.Future<$0.ReloadResponse> hotReload_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return hotReload(call, await request);
  }

  $async.Future<$0.Empty> restartPreview_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return restartPreview(call, await request);
  }

  $async.Future<$0.Empty> launchDevTools_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return launchDevTools(call, await request);
  }

  $async.Future<$0.Empty> trackUserSelection_Pre(
      $grpc.ServiceCall call, $async.Future<$0.KindInfo> request) async {
    return trackUserSelection(call, await request);
  }

  $async.Future<$0.Empty> terminatePreview_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return terminatePreview(call, await request);
  }

  $async.Future<$0.ReferenceDataInfo> getReferenceData(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.ProjectDataInfo> getProjectData(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.SelectionsStateInfo> getSelectionsState(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> setStory(
      $grpc.ServiceCall call, $0.StoryIdInfo request);
  $async.Future<$0.Empty> resetStory($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> setTextScaleFactor(
      $grpc.ServiceCall call, $0.TextScaleFactorInfo request);
  $async.Future<$0.Empty> setLocale(
      $grpc.ServiceCall call, $0.LocaleInfo request);
  $async.Future<$0.Empty> setTheme(
      $grpc.ServiceCall call, $0.ThemeInfo request);
  $async.Future<$0.Empty> setDevice(
      $grpc.ServiceCall call, $0.DeviceInfo request);
  $async.Future<$0.Empty> setScale(
      $grpc.ServiceCall call, $0.ScaleInfo request);
  $async.Future<$0.Empty> setDock($grpc.ServiceCall call, $0.DockInfo request);
  $async.Future<$0.Empty> toggleVisualDebugFlag(
      $grpc.ServiceCall call, $0.VisualDebugFlagInfo request);
  $async.Future<$0.ReloadResponse> hotReload(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> restartPreview(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> launchDevTools(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> trackUserSelection(
      $grpc.ServiceCall call, $0.KindInfo request);
  $async.Future<$0.Empty> terminatePreview(
      $grpc.ServiceCall call, $0.Empty request);
}

class MonarchPreviewNotificationsApiClient extends $grpc.Client {
  static final _$vmServerUri = $grpc.ClientMethod<$0.UriInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewNotificationsApi/VmServerUri',
      ($0.UriInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$projectDataChanged =
      $grpc.ClientMethod<$0.ProjectDataInfo, $0.Empty>(
          '/monarch_grpc.MonarchPreviewNotificationsApi/ProjectDataChanged',
          ($0.ProjectDataInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$selectionsStateChanged =
      $grpc.ClientMethod<$0.SelectionsStateInfo, $0.Empty>(
          '/monarch_grpc.MonarchPreviewNotificationsApi/SelectionsStateChanged',
          ($0.SelectionsStateInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$userMessage = $grpc.ClientMethod<$0.UserMessageInfo, $0.Empty>(
      '/monarch_grpc.MonarchPreviewNotificationsApi/UserMessage',
      ($0.UserMessageInfo value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$launchDevTools = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchPreviewNotificationsApi/LaunchDevTools',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$trackUserSelection =
      $grpc.ClientMethod<$0.UserSelectionData, $0.Empty>(
          '/monarch_grpc.MonarchPreviewNotificationsApi/TrackUserSelection',
          ($0.UserSelectionData value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  MonarchPreviewNotificationsApiClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Empty> vmServerUri($0.UriInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$vmServerUri, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> projectDataChanged($0.ProjectDataInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$projectDataChanged, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> selectionsStateChanged(
      $0.SelectionsStateInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$selectionsStateChanged, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.Empty> userMessage($0.UserMessageInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$userMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> launchDevTools($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$launchDevTools, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> trackUserSelection(
      $0.UserSelectionData request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$trackUserSelection, request, options: options);
  }
}

abstract class MonarchPreviewNotificationsApiServiceBase extends $grpc.Service {
  $core.String get $name => 'monarch_grpc.MonarchPreviewNotificationsApi';

  MonarchPreviewNotificationsApiServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.UriInfo, $0.Empty>(
        'VmServerUri',
        vmServerUri_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UriInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProjectDataInfo, $0.Empty>(
        'ProjectDataChanged',
        projectDataChanged_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProjectDataInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SelectionsStateInfo, $0.Empty>(
        'SelectionsStateChanged',
        selectionsStateChanged_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SelectionsStateInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UserMessageInfo, $0.Empty>(
        'UserMessage',
        userMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UserMessageInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'LaunchDevTools',
        launchDevTools_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UserSelectionData, $0.Empty>(
        'TrackUserSelection',
        trackUserSelection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UserSelectionData.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> vmServerUri_Pre(
      $grpc.ServiceCall call, $async.Future<$0.UriInfo> request) async {
    return vmServerUri(call, await request);
  }

  $async.Future<$0.Empty> projectDataChanged_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ProjectDataInfo> request) async {
    return projectDataChanged(call, await request);
  }

  $async.Future<$0.Empty> selectionsStateChanged_Pre($grpc.ServiceCall call,
      $async.Future<$0.SelectionsStateInfo> request) async {
    return selectionsStateChanged(call, await request);
  }

  $async.Future<$0.Empty> userMessage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.UserMessageInfo> request) async {
    return userMessage(call, await request);
  }

  $async.Future<$0.Empty> launchDevTools_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return launchDevTools(call, await request);
  }

  $async.Future<$0.Empty> trackUserSelection_Pre($grpc.ServiceCall call,
      $async.Future<$0.UserSelectionData> request) async {
    return trackUserSelection(call, await request);
  }

  $async.Future<$0.Empty> vmServerUri(
      $grpc.ServiceCall call, $0.UriInfo request);
  $async.Future<$0.Empty> projectDataChanged(
      $grpc.ServiceCall call, $0.ProjectDataInfo request);
  $async.Future<$0.Empty> selectionsStateChanged(
      $grpc.ServiceCall call, $0.SelectionsStateInfo request);
  $async.Future<$0.Empty> userMessage(
      $grpc.ServiceCall call, $0.UserMessageInfo request);
  $async.Future<$0.Empty> launchDevTools(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> trackUserSelection(
      $grpc.ServiceCall call, $0.UserSelectionData request);
}

class MonarchDiscoveryApiClient extends $grpc.Client {
  static final _$registerPreviewApi =
      $grpc.ClientMethod<$0.ServerInfo, $0.Empty>(
          '/monarch_grpc.MonarchDiscoveryApi/RegisterPreviewApi',
          ($0.ServerInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$registerPreviewNotificationsApi =
      $grpc.ClientMethod<$0.ServerInfo, $0.Empty>(
          '/monarch_grpc.MonarchDiscoveryApi/RegisterPreviewNotificationsApi',
          ($0.ServerInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getPreviewApi = $grpc.ClientMethod<$0.Empty, $0.ServerInfo>(
      '/monarch_grpc.MonarchDiscoveryApi/GetPreviewApi',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ServerInfo.fromBuffer(value));
  static final _$getPreviewNotificationsApiList =
      $grpc.ClientMethod<$0.Empty, $0.ServerListInfo>(
          '/monarch_grpc.MonarchDiscoveryApi/GetPreviewNotificationsApiList',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ServerListInfo.fromBuffer(value));

  MonarchDiscoveryApiClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Empty> registerPreviewApi($0.ServerInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerPreviewApi, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> registerPreviewNotificationsApi(
      $0.ServerInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerPreviewNotificationsApi, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ServerInfo> getPreviewApi($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPreviewApi, request, options: options);
  }

  $grpc.ResponseFuture<$0.ServerListInfo> getPreviewNotificationsApiList(
      $0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPreviewNotificationsApiList, request,
        options: options);
  }
}

abstract class MonarchDiscoveryApiServiceBase extends $grpc.Service {
  $core.String get $name => 'monarch_grpc.MonarchDiscoveryApi';

  MonarchDiscoveryApiServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ServerInfo, $0.Empty>(
        'RegisterPreviewApi',
        registerPreviewApi_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ServerInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ServerInfo, $0.Empty>(
        'RegisterPreviewNotificationsApi',
        registerPreviewNotificationsApi_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ServerInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ServerInfo>(
        'GetPreviewApi',
        getPreviewApi_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ServerInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ServerListInfo>(
        'GetPreviewNotificationsApiList',
        getPreviewNotificationsApiList_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ServerListInfo value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> registerPreviewApi_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ServerInfo> request) async {
    return registerPreviewApi(call, await request);
  }

  $async.Future<$0.Empty> registerPreviewNotificationsApi_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ServerInfo> request) async {
    return registerPreviewNotificationsApi(call, await request);
  }

  $async.Future<$0.ServerInfo> getPreviewApi_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getPreviewApi(call, await request);
  }

  $async.Future<$0.ServerListInfo> getPreviewNotificationsApiList_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getPreviewNotificationsApiList(call, await request);
  }

  $async.Future<$0.Empty> registerPreviewApi(
      $grpc.ServiceCall call, $0.ServerInfo request);
  $async.Future<$0.Empty> registerPreviewNotificationsApi(
      $grpc.ServiceCall call, $0.ServerInfo request);
  $async.Future<$0.ServerInfo> getPreviewApi(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.ServerListInfo> getPreviewNotificationsApiList(
      $grpc.ServiceCall call, $0.Empty request);
}
