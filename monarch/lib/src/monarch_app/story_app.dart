import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'active_locale.dart';
import 'active_story_scale.dart';
import 'monarch_binding.dart';
import 'monarch_data_instance.dart';
import 'ready_signal.dart';
import 'story_view.dart';

class MonarchStoryApp extends StatefulWidget {
  MonarchStoryApp();

  @override
  State<StatefulWidget> createState() {
    return _MonarchStoryAppState();
  }
}

class _MonarchStoryAppState extends State<MonarchStoryApp> {
  late bool _isReady;
  late double _storyScale;
  late Locale? _locale;
  final _streamSubscriptions = <StreamSubscription>[];

  _MonarchStoryAppState();

  @override
  void initState() {
    super.initState();

    _isReady = readySignal.isReady;
    _storyScale = activeStoryScale.value;
    _locale = activeLocale.value;

    _streamSubscriptions.addAll([
      readySignal.changeStream
          .listen((isReady) => setState(() => _isReady = isReady)),
      activeStoryScale.stream
          .listen((value) => setState(() => _storyScale = value)),
      activeLocale.stream.listen((value) => setState(() => _locale = value))
    ]);
  }

  @override
  void dispose() {
    for (var s in _streamSubscriptions) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    monarchBindingInstance.lockEventsWhileRendering();
    if (_isReady) {
      if (_locale == null) {
        return MonarchScaleMaterialApp(
            scale: _storyScale,
            home: MonarchStoryView(
              localeKey: '__NA__',
            ));
      } else {
        return MonarchLocalizedScaleMaterialApp(
            scale: _storyScale, locale: _locale!);
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

class MonarchLocalizedScaleMaterialApp extends StatelessWidget {
  final double scale;
  final Locale locale;

  MonarchLocalizedScaleMaterialApp(
      {Key? key, required this.scale, required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              ...monarchDataInstance.metaLocalizations.map((x) => x.delegate!),
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: monarchDataInstance.allLocales,
            locale: locale,
            home: MonarchStoryView(localeKey: locale.toLanguageTag())));
  }
}
