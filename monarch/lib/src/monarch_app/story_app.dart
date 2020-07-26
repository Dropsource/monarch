import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'active_locale.dart';
import 'monarch_data.dart';
import 'story_view.dart';

class StoryApp extends StatelessWidget {
  final MonarchData monarchData;

  StoryApp({this.monarchData});

  @override
  Widget build(BuildContext context) {
    if (monarchData.metaLocalizations.isEmpty) {
      return MaterialApp(
          key: ObjectKey('no-localizations'),
          home: Scaffold(
              body: StoryView(
            monarchData: monarchData,
            localeKey: '__NA__',
          )));
    } else {
      return LocalizedStoryApp(monarchData: monarchData);
    }
  }
}

class LocalizedStoryApp extends StatefulWidget {
  final MonarchData monarchData;

  LocalizedStoryApp({this.monarchData});

  @override
  State<StatefulWidget> createState() {
    return _LocalizedStoryAppState();
  }
}

class _LocalizedStoryAppState extends State<LocalizedStoryApp> {
  LoadingStatus _loadingStatus;
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
      case LoadingStatus.inProgress:
        return _buildSimpleMaterialApp('Loading locale...');

      case LoadingStatus.done:
        return _buildOnLocaleLoaded();

      case LoadingStatus.error:
        return _buildSimpleMaterialApp(
            'Unexpected error. Please see console for details.');

      default:
        throw 'Unexpected status, got $_loadingStatus';
    }
  }

  Widget _buildSimpleMaterialApp(String message) {
    return MaterialApp(
        key: ObjectKey(message), home: Scaffold(body: CenteredText(message)));
  }

  Widget _buildOnLocaleLoaded() {
    activeLocale.assertIsLoaded();
    if (activeLocale.canLoad) {
      return MaterialApp(
          key: ObjectKey(activeLocale.locale.toLanguageTag()),
          localizationsDelegates: [
            ...widget.monarchData.metaLocalizations
                .map((x) => x.delegate)
                .toList(),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: widget.monarchData.allLocales,
          locale: activeLocale.locale,
          home: Scaffold(
              body: StoryView(
                  monarchData: widget.monarchData,
                  localeKey: activeLocale.locale.toLanguageTag())));
    } else {
      return _buildSimpleMaterialApp(
          'Error loading locale ${activeLocale.locale.toLanguageTag()}. Please see '
          'console for details.');
    }
  }
}
