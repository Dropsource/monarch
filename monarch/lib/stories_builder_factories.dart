import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

// import 'src/builders/stories_builder.dart';
import 'src/builders/main_builder.dart';
import 'src/builders/meta_stories_generator.dart';
import 'src/builders/meta_themes_generator.dart';

// Builder storiesBuilder(BuilderOptions options) => StoriesBuilder();

Builder metaStoriesBuilder(BuilderOptions options) =>
    LibraryBuilder(MetaStoriesGenerator(),
        generatedExtension: '.meta_stories.g.dart');

Builder metaThemesBuilder(BuilderOptions options) =>
    LibraryBuilder(MetaThemesGenerator(),
        generatedExtension: '.meta_themes.g.dart');

Builder mainBuilder(BuilderOptions options) => MainBuilder();
