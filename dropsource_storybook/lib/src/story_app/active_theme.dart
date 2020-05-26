import 'package:dropsource_storybook_utils/log.dart';

import 'storybook_data.dart';

class ActiveTheme with Log {
  List<MetaTheme> _metaThemeList;
  List<MetaTheme> get metaThemeList => _metaThemeList;

  
}

final activeTheme = ActiveTheme();