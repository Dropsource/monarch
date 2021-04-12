import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'main_builder.dart';
import 'meta_stories_generator.dart';
import 'meta_themes_generator.dart';
import 'meta_locales_generator.dart';

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
