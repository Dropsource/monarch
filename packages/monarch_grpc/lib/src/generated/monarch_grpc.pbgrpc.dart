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

class MonarchCliClient extends $grpc.Client {
  static final _$controllerGrpcServerStarted =
      $grpc.ClientMethod<$0.ServerInfo, $0.Empty>(
          '/monarch_grpc.MonarchCli/ControllerGrpcServerStarted',
          ($0.ServerInfo value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$launchDevTools = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchCli/LaunchDevTools',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  MonarchCliClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

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
}

abstract class MonarchCliServiceBase extends $grpc.Service {
  $core.String get $name => 'monarch_grpc.MonarchCli';

  MonarchCliServiceBase() {
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
  }

  $async.Future<$0.Empty> controllerGrpcServerStarted_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ServerInfo> request) async {
    return controllerGrpcServerStarted(call, await request);
  }

  $async.Future<$0.Empty> launchDevTools_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return launchDevTools(call, await request);
  }

  $async.Future<$0.Empty> controllerGrpcServerStarted(
      $grpc.ServiceCall call, $0.ServerInfo request);
  $async.Future<$0.Empty> launchDevTools(
      $grpc.ServiceCall call, $0.Empty request);
}

class MonarchControllerClient extends $grpc.Client {
  static final _$restartPreview = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/monarch_grpc.MonarchController/RestartPreview',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  MonarchControllerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Empty> restartPreview($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restartPreview, request, options: options);
  }
}

abstract class MonarchControllerServiceBase extends $grpc.Service {
  $core.String get $name => 'monarch_grpc.MonarchController';

  MonarchControllerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'RestartPreview',
        restartPreview_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> restartPreview_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return restartPreview(call, await request);
  }

  $async.Future<$0.Empty> restartPreview(
      $grpc.ServiceCall call, $0.Empty request);
}
