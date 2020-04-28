import 'package:flutter/widgets.dart';

import 'story_app/channel_methods.dart';

typedef StoryFunction = Widget Function();

class StoriesData implements OutboundChannelArgument {
  /// Name of the user project or package
  final String package;

  /// Path to the .stories file the user authored
  final String path;

  /// List of story names in the .stories file
  final List<String> storiesNames;

  /// Maps story name to its function
  final Map<String, StoryFunction> storiesMap;

  const StoriesData(
      this.package, this.path, this.storiesNames, this.storiesMap);

  @override
  Map<String, dynamic> toStandardMap() {
    return {'package': package, 'path': path, 'storiesNames': storiesNames};
  }
}

class StorybookData implements OutboundChannelArgument {
  final String packageName;

  /// It maps generated stories path to its stories data.
  /// As of 2020-04-15, the key looks like `$packageName|$generatedStoriesFilePath`
  final Map<String, StoriesData> storiesDataMap;

  StorybookData(this.packageName, this.storiesDataMap);

  @override
  Map<String, dynamic> toStandardMap() {
    return {
      'packageName': packageName,
      'storiesDataMap': storiesDataMap
          .map((key, value) => MapEntry(key, value.toStandardMap()))
    };
  }
}
