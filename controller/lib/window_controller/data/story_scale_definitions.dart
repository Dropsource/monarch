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

final defaultScaleDefinition = StoryScaleDefinition(1, '100%');
final storyScaleDefinitions = [
  StoryScaleDefinition(0.5, '50%'),
  StoryScaleDefinition(0.67, '67%'),
  StoryScaleDefinition(0.75, '75%'),
  StoryScaleDefinition(0.8, '80%'),
  StoryScaleDefinition(0.9, '90%'),
  defaultScaleDefinition,
  StoryScaleDefinition(1.1, '110%'),
  StoryScaleDefinition(1.25, '125%'),
  StoryScaleDefinition(1.5, '150%'),
  StoryScaleDefinition(1.75, '175%'),
  StoryScaleDefinition(2, '200%'),
  StoryScaleDefinition(2.5, '250%'),
  StoryScaleDefinition(3, '300%'),
];
