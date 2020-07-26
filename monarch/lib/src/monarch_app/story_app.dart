import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'active_locale.dart';
import 'active_device.dart';
import 'active_story.dart';
import 'active_theme.dart';
import 'device_definitions.dart';
import 'localizations_delegate_loader.dart';
import 'monarch_data.dart';

class StoryApp extends StatefulWidget {
  final MonarchData monarchData;
  final LocalizationsDelegateLoader localizationsDelegateLoader;

  StoryApp({this.monarchData, this.localizationsDelegateLoader});

  @override
  State<StatefulWidget> createState() {
    return _StoryAppState();
  }
}

class _StoryAppState extends State<StoryApp> {
  Locale _locale;
  DeviceDefinition _device;
  String _themeId;
  ThemeData _themeData;

  String _storyKey;
  StoryFunction _storyFunction;

  final _streamSubscriptions = <StreamSubscription>[];

  _StoryAppState();

  @override
  void initState() {
    super.initState();

    _setLocale();
    _setDeviceDefinition();
    _setThemeData();

    _streamSubscriptions.addAll([
      activeLocale.activeLocaleStream.listen((_) => setState(_setLocale)),
      activeDevice.activeDeviceStream
          .listen((_) => setState(_setDeviceDefinition)),
      activeTheme.activeMetaThemeStream.listen((_) => setState(_setThemeData)),
      activeStory.activeStoryChangeStream
          .listen((_) => setState(_setStoryFunction))
    ]);
  }

  void _setLocale() {
    _locale = activeLocale.activeLocale;
  }

  void _setDeviceDefinition() {
    _device = activeDevice.activeDevice;
  }

  void _setThemeData() {
    _themeData = activeTheme.activeMetaTheme.theme;
    _themeId = activeTheme.activeMetaTheme.id;
  }

  void _setStoryFunction() {
    final activeStoryId = activeStory.activeStoryId;

    if (activeStoryId == null) {
      _storyKey = null;
      _storyFunction = null;
    } else {
      final metaStories =
          widget.monarchData.metaStoriesMap[activeStoryId.pathKey];
      _storyKey = activeStory.activeStoryId.storyKey;
      _storyFunction = metaStories.storiesMap[activeStoryId.name];
    }
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  String get keyValue => '$_storyKey|$_themeId|${_device.id}';

  @override
  Widget build(BuildContext context) {
    if (widget.monarchData.metaLocalizations.isEmpty) {
      return MaterialApp(home: Scaffold(body: _buildStoryView()));
    } else {
      return FutureBuilder<bool>(
        future: widget.localizationsDelegateLoader.canLoad(_locale),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            final canLoadLocale = snapshot.data;
            if (canLoadLocale) {
              return MaterialApp(
                  localizationsDelegates: [
                    ...widget.monarchData.metaLocalizations
                        .map((x) => x.delegate)
                        .toList(),
                    ...GlobalMaterialLocalizations.delegates,
                  ],
                  supportedLocales: widget.monarchData.allLocales,
                  locale: _locale,
                  home: Scaffold(body: _buildStoryView()));
            } else {
              return MaterialApp(
                  home: Scaffold(body: _buildLocaleErrorView()));
            }
          } else {
            return MaterialApp(
                home: Scaffold(body: _buildLocaleLoadingView()));
          }
        },
      );
    }
  }

  Widget _buildStoryView() {
    ArgumentError.checkNotNull(_device, '_device');
    ArgumentError.checkNotNull(_themeId, '_themeId');
    ArgumentError.checkNotNull(_themeData, '_themeData');

    if (_storyFunction == null) {
      return Center(child: Text('Please select a story'));
    } else {
      return Theme(
          key: ObjectKey(keyValue),
          child: MediaQuery(
              data: MediaQueryData(
                  size: Size(_device.logicalResolution.width,
                      _device.logicalResolution.height),
                  devicePixelRatio: _device.devicePixelRatio),
              child: _storyFunction()),
          data: _themeData.copyWith(platform: _device.targetPlatform));
    }
  }

  Widget _buildLocaleLoadingView() {
    return Center(child: Text('Loading locale...'));
  }

  Widget _buildLocaleErrorView() {
    return Center(child: Text('Error loading the selected locale. Please see console for details.'));
  }
}
