import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

// import 'src/builders/stories_builder.dart';
import 'src/builders/main_builder.dart';
import 'src/builders/meta_stories_generator.dart';
import 'src/builders/meta_themes_generator.dart';
import 'src/builders/meta_locales_generator.dart';

Builder metaLocalizationsBuilder(BuilderOptions options) =>
    LibraryBuilder(MetaLocalizationsGenerator(),
        generatedExtension: '.meta_localizations.g.dart',
        allowSyntaxErrors: true);

Builder metaThemesBuilder(BuilderOptions options) =>
    LibraryBuilder(MetaThemesGenerator(),
        generatedExtension: '.meta_themes.g.dart', allowSyntaxErrors: true);

Builder metaStoriesBuilder(BuilderOptions options) =>
    LibraryBuilder(MetaStoriesGenerator(),
        generatedExtension: '.meta_stories.g.dart', allowSyntaxErrors: true);

Builder mainBuilder(BuilderOptions options) => MainBuilder();
