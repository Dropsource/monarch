import 'package:build/build.dart';

import 'main_builder.dart';
import 'meta_stories_builder.dart';
import 'meta_themes_builder.dart';
import 'meta_localizations_builder.dart';

Builder metaLocalizationsBuilder(BuilderOptions options) =>
    MetaLocalizationsBuilder();

Builder metaThemesBuilder(BuilderOptions options) => MetaThemesBuilder();

Builder metaStoriesBuilder(BuilderOptions options) => MetaStoriesBuilder();

Builder mainBuilder(BuilderOptions options) => MainBuilder(options);
