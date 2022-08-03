import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'active_locale.dart';
import 'active_story_scale.dart';
import 'monarch_binding.dart';
import 'monarch_data_manager.dart';
import 'ready_signal.dart';
import 'story_view.dart';

class MonarchPreview extends StatefulWidget {
  MonarchPreview();

  @override
  State<StatefulWidget> createState() {
    return _MonarchPreviewState();
  }
}

class _MonarchPreviewState extends State<MonarchPreview> {
  late bool _isReady;
  late double _storyScale;
  late Locale? _locale;
  final _streamSubscriptions = <StreamSubscription>[];

  _MonarchPreviewState();

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
    MonarchBinding.instance.lockEventsWhileRendering();
    if (_isReady) {
      return MonarchMaterialApp(
          scale: _storyScale, locale: _locale, home: MonarchStoryView());
    } else {
      return MonarchMaterialApp(
          scale: _storyScale,
          locale: null,
          home: MonarchSimpleMessageView(message: 'Loading...'));
    }
  }
}

class MonarchMaterialApp extends StatelessWidget {
  final double scale;
  final Locale? locale;
  final Widget home;

  MonarchMaterialApp(
      {Key? key, required this.scale, required this.locale, required this.home})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: scale,
        alignment: Alignment.topLeft,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            scrollBehavior: MonarchScrollBehavior(),
            localizationsDelegates: locale == null ||
                    monarchDataManager.data!.metaLocalizations.isEmpty
                ? null
                : [
                    ...monarchDataManager.data!.metaLocalizations
                        .map((x) => x.delegate!),
                    ...GlobalMaterialLocalizations.delegates,
                  ],
            supportedLocales:
                locale == null || monarchDataManager.data!.allLocales.isEmpty
                    ? const <Locale>[Locale('en', 'US')]
                    : monarchDataManager.data!.allLocales,
            locale: locale,
            home: home));
  }
}

class MonarchScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
