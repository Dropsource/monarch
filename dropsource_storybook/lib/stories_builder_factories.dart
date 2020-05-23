import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/builders/stories_builder.dart';
import 'src/builders/main_storybook_builder.dart';
import 'src/builders/themes_generator.dart';

Builder storiesBuilder(BuilderOptions options) => StoriesBuilder();

Builder mainStorybookBuilder(BuilderOptions options) => MainStorybookBuilder();

Builder themesBuilder(BuilderOptions options) =>
    LibraryBuilder(ThemesGenerator(),
        generatedExtension: '.storybook_themes.g.dart');
