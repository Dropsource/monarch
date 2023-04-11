import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'main_builder.dart';
import 'meta_stories_builder.dart';
import 'meta_themes_builder.dart';
import 'meta_locales_generator.dart';

Builder metaLocalizationsBuilder(BuilderOptions options) =>
    LibraryBuilder(MetaLocalizationsGenerator(),
        generatedExtension: '.meta_localizations.g.dart',
        allowSyntaxErrors: true);

Builder metaThemesBuilder(BuilderOptions options) => MetaThemesBuilder();

Builder metaStoriesBuilder(BuilderOptions options) => MetaStoriesBuilder();

Builder mainBuilder(BuilderOptions options) => MainBuilder(options);
