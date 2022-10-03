///
//  Generated code. Do not modify.
//  source: monarch_grpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'monarch_grpc.pb.dart' as $0;
export 'monarch_grpc.pb.dart';

class MonarchCliClient extends $grpc.Client {
  static final _$previewVmServerUriChanged =
      $grpc.ClientMethod<$0.UriInfo, $0.Empty>(
          '/monarch_grpc.MonarchCli/PreviewVmServerUriChanged',
          ($0.UriInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$controllerGrpcServerStarted =
      $grpc.ClientMethod<$0.ServerInfo, $0.Empty>(
          '/monarch_grpc.MonarchCli/ControllerGrpcServerStarted',
          ($0.ServerInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$launchDevTools = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchCli/LaunchDevTools',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$printUserMessage =
      $grpc.ClientMethod<$0.UserMessage, $0.Empty>(
          '/monarch_grpc.MonarchCli/PrintUserMessage',
          ($0.UserMessage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$userSelection =
      $grpc.ClientMethod<$0.UserSelectionData, $0.Empty>(
          '/monarch_grpc.MonarchCli/UserSelection',
          ($0.UserSelectionData value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  MonarchCliClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Empty> previewVmServerUriChanged($0.UriInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$previewVmServerUriChanged, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.Empty> controllerGrpcServerStarted(
      $0.ServerInfo request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$controllerGrpcServerStarted, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.Empty> launchDevTools($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$launchDevTools, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> printUserMessage($0.UserMessage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$printUserMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> userSelection($0.UserSelectionData request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$userSelection, request, options: options);
  }
}

abstract class MonarchCliServiceBase extends $grpc.Service {
  $core.String get $name => 'monarch_grpc.MonarchCli';

  MonarchCliServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.UriInfo, $0.Empty>(
        'PreviewVmServerUriChanged',
        previewVmServerUriChanged_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UriInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ServerInfo, $0.Empty>(
        'ControllerGrpcServerStarted',
        controllerGrpcServerStarted_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ServerInfo.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'LaunchDevTools',
        launchDevTools_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UserMessage, $0.Empty>(
        'PrintUserMessage',
        printUserMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UserMessage.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UserSelectionData, $0.Empty>(
        'UserSelection',
        userSelection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UserSelectionData.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> previewVmServerUriChanged_Pre(
      $grpc.ServiceCall call, $async.Future<$0.UriInfo> request) async {
    return previewVmServerUriChanged(call, await request);
  }

  $async.Future<$0.Empty> controllerGrpcServerStarted_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ServerInfo> request) async {
    return controllerGrpcServerStarted(call, await request);
  }

  $async.Future<$0.Empty> launchDevTools_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return launchDevTools(call, await request);
  }

  $async.Future<$0.Empty> printUserMessage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.UserMessage> request) async {
    return printUserMessage(call, await request);
  }

  $async.Future<$0.Empty> userSelection_Pre($grpc.ServiceCall call,
      $async.Future<$0.UserSelectionData> request) async {
    return userSelection(call, await request);
  }

  $async.Future<$0.Empty> previewVmServerUriChanged(
      $grpc.ServiceCall call, $0.UriInfo request);
  $async.Future<$0.Empty> controllerGrpcServerStarted(
      $grpc.ServiceCall call, $0.ServerInfo request);
  $async.Future<$0.Empty> launchDevTools(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> printUserMessage(
      $grpc.ServiceCall call, $0.UserMessage request);
  $async.Future<$0.Empty> userSelection(
      $grpc.ServiceCall call, $0.UserSelectionData request);
}

class MonarchControllerClient extends $grpc.Client {
  static final _$hotReload = $grpc.ClientMethod<$0.Empty, $0.ReloadResponse>(
      '/monarch_grpc.MonarchController/HotReload',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ReloadResponse.fromBuffer(value));
  static final _$restartPreview = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchController/RestartPreview',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  MonarchControllerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.ReloadResponse> hotReload($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$hotReload, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> restartPreview($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restartPreview, request, options: options);
  }
}

abstract class MonarchControllerServiceBase extends $grpc.Service {
  $core.String get $name => 'monarch_grpc.MonarchController';

  MonarchControllerServiceBase() {
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
  }

  $async.Future<$0.ReloadResponse> hotReload_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return hotReload(call, await request);
  }

  $async.Future<$0.Empty> restartPreview_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return restartPreview(call, await request);
  }

  $async.Future<$0.ReloadResponse> hotReload(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> restartPreview(
      $grpc.ServiceCall call, $0.Empty request);
}
