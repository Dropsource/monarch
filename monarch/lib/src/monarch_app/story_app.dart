import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ready_signal.dart';
import 'active_locale.dart';
import 'active_story_scale.dart';
import 'monarch_data.dart';
import 'story_view.dart';

class StoryApp extends StatefulWidget {
  final MonarchData monarchData;

  StoryApp({required this.monarchData});

  @override
  State<StatefulWidget> createState() {
    return _StoryAppState();
  }
}

class _StoryAppState extends State<StoryApp> {
  late bool _isReady;
  final _streamSubscriptions = <StreamSubscription>[];

  _StoryAppState();

  @override
  void initState() {
    super.initState();

    _isReady = readySignal.isReady;

    _streamSubscriptions.add(readySignal.changeStream
        .listen((isReady) => setState(() => _isReady = isReady)));
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      if (widget.monarchData.metaLocalizations.isEmpty) {
        return MaterialApp(
            key: ObjectKey('no-localizations'),
            debugShowCheckedModeBanner: false,
            home: ScaleScaffold(
                body: StoryView(
              monarchData: widget.monarchData,
              localeKey: '__NA__',
            )));
      } else {
        return LocalizedStoryApp(monarchData: widget.monarchData);
      }
    } else {
      return SimpleMaterialApp(message: 'Loading...');
    }
  }
}

class LocalizedStoryApp extends StatefulWidget {
  final MonarchData monarchData;

  LocalizedStoryApp({required this.monarchData});

  @override
  State<StatefulWidget> createState() {
    return _LocalizedStoryAppState();
  }
}

class _LocalizedStoryAppState extends State<LocalizedStoryApp> {
  late LocaleLoadingStatus _loadingStatus;
  final _streamSubscriptions = <StreamSubscription>[];

  _LocalizedStoryAppState();

  @override
  void initState() {
    super.initState();

    _loadingStatus = activeLocale.loadingStatus;
    _streamSubscriptions.add(activeLocale.loadingStatusStream
        .listen((status) => setState(() => _loadingStatus = status)));
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loadingStatus) {
      case LocaleLoadingStatus.inProgress:
        return SimpleMaterialApp(message: 'Loading locale...');

      case LocaleLoadingStatus.done:
        return _buildOnLocaleLoaded();

      case LocaleLoadingStatus.error:
        return SimpleMaterialApp(
            message: 'Unexpected error. Please see console for details.');

      default:
        throw 'Unexpected status, got $_loadingStatus';
    }
  }

  Widget _buildOnLocaleLoaded() {
    activeLocale.assertIsLoaded();
    if (activeLocale.canLoad!) {
      return MaterialApp(
          key: ObjectKey(activeLocale.locale!.toLanguageTag()),
          localizationsDelegates: [
            ...widget.monarchData.metaLocalizations.map((x) => x.delegate!),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: widget.monarchData.allLocales,
          locale: activeLocale.locale,
          debugShowCheckedModeBanner: false,
          home: ScaleScaffold(
              body: StoryView(
                  monarchData: widget.monarchData,
                  localeKey: activeLocale.locale!.toLanguageTag())));
    } else {
      return SimpleMaterialApp(
          message:
              'Error loading locale ${activeLocale.locale!.toLanguageTag()}. '
              'Please see console for details.');
    }
  }
}

class SimpleMaterialApp extends StatelessWidget {
  SimpleMaterialApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        key: ObjectKey(message),
        debugShowCheckedModeBanner: false,
        home: ScaleScaffold(body: CenteredText(message)));
  }
}

class ScaleScaffold extends StatefulWidget {
  final Widget? body;

  ScaleScaffold({this.body});

  @override
  State<StatefulWidget> createState() {
    return _ScaleScaffoldState();
  }
}

class _ScaleScaffoldState extends State<ScaleScaffold> {
  late double _storyScale;
  final _streamSubscriptions = <StreamSubscription>[];

  _ScaleScaffoldState();

  @override
  void initState() {
    super.initState();

    _setStoryScale();

    _streamSubscriptions
        .add(activeStoryScale.stream.listen((_) => setState(_setStoryScale)));
  }

  void _setStoryScale() => _storyScale = activeStoryScale.value;

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: _storyScale,
        alignment: Alignment.topLeft,
        child: Scaffold(body: widget.body));
  }
}
