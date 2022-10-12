import 'dart:async';

import 'package:monarch_definitions/monarch_definitions.dart';
import 'package:monarch_grpc/monarch_grpc.dart';

import 'project_data.dart';

class SelectionsState {
  final StoryId? storyId;
  final DeviceDefinition device;
  final MetaThemeDefinition theme;
  final String languageTag;
  final double textScaleFactor;
  final StoryScaleDefinition scale;
  final DockDefinition dock;
  final Map<String, bool> visualDebugFlags;

  SelectionsState({
    required this.storyId,
    required this.device,
    required this.theme,
    required this.languageTag,
    required this.textScaleFactor,
    required this.scale,
    required this.dock,
    required this.visualDebugFlags,
  });

  factory SelectionsState.init() => SelectionsState(
      storyId: null,
      device: defaultDeviceDefinition,
      theme: defaultThemeDefinition,
      languageTag: defaultLocale,
      textScaleFactor: 1.0,
      scale: defaultScaleDefinition,
      dock: defaultDockDefinition,
      visualDebugFlags: defaultVisualDebugFlags);

  SelectionsState copyWith({
    StoryId? storyId,
    DeviceDefinition? device,
    MetaThemeDefinition? theme,
    String? languageTag,
    double? textScaleFactor,
    StoryScaleDefinition? scale,
    DockDefinition? dock,
    Map<String, bool>? visualDebugFlags,
  }) =>
      SelectionsState(
          storyId: storyId ?? this.storyId,
          device: device ?? this.device,
          theme: theme ?? this.theme,
          languageTag: languageTag ?? this.languageTag,
          textScaleFactor: textScaleFactor ?? this.textScaleFactor,
          scale: scale ?? this.scale,
          dock: dock ?? this.dock,
          visualDebugFlags: visualDebugFlags ?? this.visualDebugFlags);

  SelectionsStateInfo toInfo() => SelectionsStateInfo(
        storyId: storyId == null ? null : StoryIdInfoMapper().toInfo(storyId!),
        device: DeviceInfoMapper().toInfo(device),
        theme: ThemeInfoMapper().toInfo(theme),
        locale: LocaleInfo(languageTag: languageTag),
        textScaleFactor: textScaleFactor,
        scale: ScaleInfoMapper().toInfo(scale),
        dock: DockInfoMapper().toInfo(dock),
        visualDebugFlags: visualDebugFlags,
      );

  Map<String, dynamic> toStandardMap() {
    return {
      'storyId':
          storyId == null ? null : StoryIdMapper().toStandardMap(storyId!),
      'device': DeviceDefinitionMapper().toStandardMap(device),
      'scale': StoryScaleDefinitionMapper().toStandardMap(scale),
      'dock': dock.id,
      'themeId': theme.id,
      'locale': languageTag,
      'textScaleFactor': textScaleFactor,
      'visualDebugFlags': visualDebugFlags.entries.map((e) =>
          VisualDebugFlagMapper()
              .toStandardMap(VisualDebugFlag(name: e.key, isEnabled: e.value)))
    };
  }
}

class SelectionsStateManager {
  SelectionsState _state = SelectionsState.init();
  SelectionsState get state => _state;

  final _controller = StreamController<SelectionsState>.broadcast();
  Stream<SelectionsState> get stream => _controller.stream;

  void update(SelectionsState Function(SelectionsState state) fn) {
    _state = fn(_state);
    _controller.add(_state);
  }

  void close() {
    _controller.close();
  }
}
