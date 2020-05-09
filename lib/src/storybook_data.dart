import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

import 'story_app/channel_methods.dart';

typedef StoryFunction = Widget Function();

class StoriesData implements OutboundChannelArgument {
  /// Name of the user project or package
  final String package;

  /// Path to the .stories file the user authored.
  /// As of 2020-05-08, this path is relative to the stories directory.
  /// It looks like 'stories/foo.stories.dart'.
  final String path;

  /// List of story names in the .stories file
  final List<String> storiesNames;

  /// Maps story name to its function
  final Map<String, StoryFunction> storiesMap;

  const StoriesData(
      this.package, this.path, this.storiesNames, this.storiesMap);

  String get pathFirstPartRemoved {
    final parts = p.split(path);
    parts..removeAt(0);
    return p.joinAll(parts);
  }

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
