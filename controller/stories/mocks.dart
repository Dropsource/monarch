import 'package:grpc/src/client/method.dart';
import 'package:grpc/src/client/common.dart';
import 'package:grpc/src/client/call.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

class FakeResponseFuture<R> implements ResponseFuture<R> {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'Member ${invocation.memberName} on FakeResponseFuture is not implemented');
}

class MockMonarchPreviewApiClient implements MonarchPreviewApiClient {
  @override
  ClientCall<Q, R> $createCall<Q, R>(
      ClientMethod<Q, R> method, Stream<Q> requests,
      {CallOptions? options}) {
    throw UnimplementedError();
  }

  @override
  ResponseStream<R> $createStreamingCall<Q, R>(
      ClientMethod<Q, R> method, Stream<Q> requests,
      {CallOptions? options}) {
    throw UnimplementedError();
  }

  @override
  ResponseFuture<R> $createUnaryCall<Q, R>(ClientMethod<Q, R> method, Q request,
      {CallOptions? options}) {
    throw UnimplementedError();
  }

  @override
  ResponseFuture<ProjectDataInfo> getProjectData(Empty request,
      {CallOptions? options}) {
    throw UnimplementedError();
  }

  @override
  ResponseFuture<ReferenceDataInfo> getReferenceData(Empty request,
      {CallOptions? options}) {
    throw UnimplementedError();
  }

  @override
  ResponseFuture<SelectionsStateInfo> getSelectionsState(Empty request,
      {CallOptions? options}) {
    throw UnimplementedError();
  }

  @override
  ResponseFuture<ReloadResponse> hotReload(Empty request,
      {CallOptions? options}) {
    throw UnimplementedError();
  }

  @override
  ResponseFuture<Empty> launchDevTools(Empty request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> resetStory(Empty request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> restartPreview(Empty request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> setDevice(DeviceInfo request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> setDock(DockInfo request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> setLocale(LocaleInfo request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> setScale(ScaleInfo request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> setStory(StoryIdInfo request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> setTextScaleFactor(TextScaleFactorInfo request,
      {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> setTheme(ThemeInfo request, {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> terminatePreview(Empty request,
      {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> toggleVisualDebugFlag(VisualDebugFlagInfo request,
      {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }

  @override
  ResponseFuture<Empty> trackUserSelection(KindInfo request,
      {CallOptions? options}) {
    return FakeResponseFuture<Empty>();
  }
}
