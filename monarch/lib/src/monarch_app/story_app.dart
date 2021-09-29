import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'active_locale.dart';
import 'active_story_scale.dart';
import 'monarch_data.dart';
import 'ready_signal.dart';
import 'story_view.dart';

class MonarchStoryApp extends StatefulWidget {
  final MonarchData monarchData;

  MonarchStoryApp({required this.monarchData});

  @override
  State<StatefulWidget> createState() {
    return _MonarchStoryAppState();
  }
}

class _MonarchStoryAppState extends State<MonarchStoryApp> {
  late bool _isReady;
  late double _storyScale;
  late LocaleLoadingStatus _localeLoadingStatus;
  final _streamSubscriptions = <StreamSubscription>[];

  _MonarchStoryAppState();

  @override
  void initState() {
    super.initState();

    _isReady = readySignal.isReady;
    _storyScale = activeStoryScale.value;
    _localeLoadingStatus = activeLocale.loadingStatus;

    _streamSubscriptions.addAll([
      readySignal.changeStream
          .listen((isReady) => setState(() => _isReady = isReady)),
      activeStoryScale.stream
          .listen((value) => setState(() => _storyScale = value)),
      activeLocale.loadingStatusStream
          .listen((status) => setState(() => _localeLoadingStatus = status))
    ]);
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
        return MonarchScaleMaterialApp(
            scale: _storyScale,
            home: MonarchStoryView(
              monarchData: widget.monarchData,
              localeKey: '__NA__',
            ));
      } else {
        return MonarchLocalizedStoryApp(
            monarchData: widget.monarchData,
            scale: _storyScale,
            loadingStatus: _localeLoadingStatus);
      }
    } else {
      return MonarchScaleMaterialApp(
          scale: _storyScale,
          home: MonarchSimpleMessageView(message: 'Loading...'));
    }
  }
}

class MonarchScaleMaterialApp extends StatelessWidget {
  final double scale;
  final Widget? home;

  MonarchScaleMaterialApp({Key? key, required this.scale, this.home})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: MaterialApp(debugShowCheckedModeBanner: false, home: home));
  }
}

class MonarchLocalizedStoryApp extends StatelessWidget {
  final MonarchData monarchData;
  final double scale;
  final LocaleLoadingStatus loadingStatus;

  MonarchLocalizedStoryApp(
      {Key? key,
      required this.monarchData,
      required this.scale,
      required this.loadingStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (loadingStatus) {
      case LocaleLoadingStatus.initial:
      case LocaleLoadingStatus.inProgress:
        return MonarchScaleMaterialApp(
            scale: scale,
            home: MonarchSimpleMessageView(message: 'Loading locale...'));

      case LocaleLoadingStatus.done:
        return _buildOnLocaleLoaded();

      case LocaleLoadingStatus.error:
        return MonarchScaleMaterialApp(
            scale: scale,
            home: MonarchSimpleMessageView(
                message: 'Unexpected error. Please see console for details.'));

      default:
        throw 'Unexpected status, got $loadingStatus';
    }
  }

  Widget _buildOnLocaleLoaded() {
    activeLocale.assertIsLoaded();
    if (activeLocale.canLoad!) {
      return MonarchLocalizedScaleMaterialApp(
          scale: scale,
          localizationsDelegates: [
            ...monarchData.metaLocalizations.map((x) => x.delegate!),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: monarchData.allLocales,
          locale: activeLocale.locale,
          home: MonarchStoryView(
              monarchData: monarchData,
              localeKey: activeLocale.locale!.toLanguageTag()));
    } else {
      return MonarchScaleMaterialApp(
          scale: scale,
          home: MonarchSimpleMessageView(
              message:
                  'Error loading locale ${activeLocale.locale!.toLanguageTag()}. '
                  'Please see console for details.'));
    }
  }
}

class MonarchLocalizedScaleMaterialApp extends StatelessWidget {
  final double scale;
  final Widget? home;

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;

  MonarchLocalizedScaleMaterialApp(
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
