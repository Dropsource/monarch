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
  final _streamSubscriptions = <StreamSubscription>[];

  _MonarchStoryAppState();

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
    return MonarchStoryAppHelper(
        isReady: _isReady, monarchData: widget.monarchData, scale: _storyScale);
  }
}

class MonarchStoryAppHelper extends StatelessWidget {
  final MonarchData monarchData;
  final bool isReady;
  final double scale;

  MonarchStoryAppHelper(
      {required this.monarchData, required this.isReady, required this.scale});

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      if (monarchData.metaLocalizations.isEmpty) {
        return MonarchScaleMaterialApp(
            key: ValueKey('no-localizations'),
            scale: scale,
            home: MonarchStoryView(
              monarchData: monarchData,
              localeKey: '__NA__',
            ));
      } else {
        return MonarchLocalizedStoryApp(monarchData: monarchData, scale: scale);
      }
    } else {
      return MonarchScaleMaterialApp(
          key: ValueKey('loading'),
          scale: scale,
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

class MonarchLocalizedStoryApp extends StatefulWidget {
  final MonarchData monarchData;
  final double scale;

  MonarchLocalizedStoryApp({required this.monarchData, required this.scale});

  @override
  State<StatefulWidget> createState() {
    return _MonarchLocalizedStoryAppState();
  }
}

class _MonarchLocalizedStoryAppState extends State<MonarchLocalizedStoryApp> {
  late LocaleLoadingStatus _loadingStatus;
  final _streamSubscriptions = <StreamSubscription>[];

  _MonarchLocalizedStoryAppState();

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
        return MonarchScaleMaterialApp(
            key: ValueKey('loading-locale'),
            scale: widget.scale,
            home: MonarchSimpleMessageView(message: 'Loading locale...'));

      case LocaleLoadingStatus.done:
        return _buildOnLocaleLoaded();

      case LocaleLoadingStatus.error:
        return MonarchScaleMaterialApp(
            key: ValueKey('unexpected-error'),
            scale: widget.scale,
            home: MonarchSimpleMessageView(
                message: 'Unexpected error. Please see console for details.'));

      default:
        throw 'Unexpected status, got $_loadingStatus';
    }
  }

  Widget _buildOnLocaleLoaded() {
    activeLocale.assertIsLoaded();
    if (activeLocale.canLoad!) {
      return MonarchLocalizedScaleMaterialApp(
          key: ObjectKey(activeLocale.locale!.toLanguageTag()),
          scale: widget.scale,
          localizationsDelegates: [
            ...widget.monarchData.metaLocalizations.map((x) => x.delegate!),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: widget.monarchData.allLocales,
          locale: activeLocale.locale,
          home: MonarchStoryView(
              monarchData: widget.monarchData,
              localeKey: activeLocale.locale!.toLanguageTag()));
    } else {
      return MonarchScaleMaterialApp(
          key: ValueKey(
              'error-loading-locale-${activeLocale.locale!.toLanguageTag()}'),
          scale: widget.scale,
          home: MonarchSimpleMessageView(
              message:
                  'Error loading locale ${activeLocale.locale!.toLanguageTag()}. '
                  'Please see console for details.'));
    }
  }
}
