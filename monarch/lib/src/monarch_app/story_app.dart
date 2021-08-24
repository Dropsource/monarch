import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'active_locale.dart';
import 'active_story_scale.dart';
import 'monarch_data.dart';
import 'ready_signal.dart';
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
  late double _storyScale;
  final _streamSubscriptions = <StreamSubscription>[];

  _StoryAppState();

  @override
  void initState() {
    super.initState();

    _isReady = readySignal.isReady;
    _setStoryScale();

    _streamSubscriptions.addAll([
      readySignal.changeStream
          .listen((isReady) => setState(() => _isReady = isReady)),
      activeStoryScale.stream.listen((_) => setState(_setStoryScale)),
    ]);
  }

  void _setStoryScale() => _storyScale = activeStoryScale.value;

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoryAppHelper(
        isReady: _isReady, monarchData: widget.monarchData, scale: _storyScale);
  }
}

class StoryAppHelper extends StatelessWidget {
  final MonarchData monarchData;
  final bool isReady;
  final double scale;

  StoryAppHelper(
      {required this.monarchData, required this.isReady, required this.scale});

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      if (monarchData.metaLocalizations.isEmpty) {
        return ScaleMaterialApp(
            key: ValueKey('no-localizations'),
            scale: scale,
            home: StoryView(
              monarchData: monarchData,
              localeKey: '__NA__',
            ));
      } else {
        return LocalizedStoryApp(monarchData: monarchData, scale: scale);
      }
    } else {
      return ScaleMaterialApp(
          key: ValueKey('loading'),
          scale: scale,
          home: SimpleMessageView(message: 'Loading...'));
    }
  }
}

class ScaleMaterialApp extends StatelessWidget {
  final double scale;
  final Widget? home;

  ScaleMaterialApp({Key? key, required this.scale, this.home})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: MaterialApp(debugShowCheckedModeBanner: false, home: home));
  }
}

class LocalizedScaleMaterialApp extends StatelessWidget {
  final double scale;
  final Widget? home;

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;

  LocalizedScaleMaterialApp(
      {Key? key,
      required this.scale,
      this.home,
      this.localizationsDelegates,
      required this.supportedLocales,
      this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: home,
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
            locale: locale));
  }
}

class LocalizedStoryApp extends StatefulWidget {
  final MonarchData monarchData;
  final double scale;

  LocalizedStoryApp({required this.monarchData, required this.scale});

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
        return ScaleMaterialApp(
            key: ValueKey('loading-locale'),
            scale: widget.scale,
            home: SimpleMessageView(message: 'Loading locale...'));

      case LocaleLoadingStatus.done:
        return _buildOnLocaleLoaded();

      case LocaleLoadingStatus.error:
        return ScaleMaterialApp(
            key: ValueKey('unexpected-error'),
            scale: widget.scale,
            home: SimpleMessageView(
                message: 'Unexpected error. Please see console for details.'));

      default:
        throw 'Unexpected status, got $_loadingStatus';
    }
  }

  Widget _buildOnLocaleLoaded() {
    activeLocale.assertIsLoaded();
    if (activeLocale.canLoad!) {
      return LocalizedScaleMaterialApp(
          key: ObjectKey(activeLocale.locale!.toLanguageTag()),
          scale: widget.scale,
          localizationsDelegates: [
            ...widget.monarchData.metaLocalizations.map((x) => x.delegate!),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: widget.monarchData.allLocales,
          locale: activeLocale.locale,
          home: StoryView(
              monarchData: widget.monarchData,
              localeKey: activeLocale.locale!.toLanguageTag()));
    } else {
      return ScaleMaterialApp(
          key: ValueKey(
              'error-loading-locale-${activeLocale.locale!.toLanguageTag()}'),
          scale: widget.scale,
          home: SimpleMessageView(
              message:
                  'Error loading locale ${activeLocale.locale!.toLanguageTag()}. '
                  'Please see console for details.'));
    }
  }
}
