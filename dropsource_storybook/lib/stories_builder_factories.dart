import 'package:build/build.dart';

import 'src/builders/stories_builder.dart';
import 'src/builders/main_storybook_builder.dart';

Builder storiesBuilder(BuilderOptions options) => StoriesBuilder();

Builder mainStorybookBuilder(BuilderOptions options) => MainStorybookBuilder();
