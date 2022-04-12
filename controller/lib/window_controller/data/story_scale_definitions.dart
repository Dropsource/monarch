import 'channel_methods.dart';

class StoryScaleDefinition implements OutboundChannelArgument {
  const StoryScaleDefinition(this.scale, this.name);

  final double scale;
  final String name;

  @override
  Map<String, dynamic> toStandardMap() {
    return {'scale': scale, 'name': name};
  }
}

class StoryScaleDefinitions implements OutboundChannelArgument {
  @override
  Map<String, dynamic> toStandardMap() {
    return {
      'definitions':
          storyScaleDefinitions.map((d) => d.toStandardMap()).toList(),
    };
  }
}

const defaultScaleDefinition = StoryScaleDefinition(1, '100%');
final storyScaleDefinitions = [
  const StoryScaleDefinition(0.5, '50%'),
  const StoryScaleDefinition(0.67, '67%'),
  const StoryScaleDefinition(0.75, '75%'),
  const StoryScaleDefinition(0.8, '80%'),
  const StoryScaleDefinition(0.9, '90%'),
  defaultScaleDefinition,
  const StoryScaleDefinition(1.1, '110%'),
  const StoryScaleDefinition(1.25, '125%'),
  const StoryScaleDefinition(1.5, '150%'),
  const StoryScaleDefinition(1.75, '175%'),
  const StoryScaleDefinition(2, '200%'),
  const StoryScaleDefinition(2.5, '250%'),
  const StoryScaleDefinition(3, '300%'),
];
