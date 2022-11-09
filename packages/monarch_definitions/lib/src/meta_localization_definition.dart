import 'standard_mapper.dart';

const defaultLocale = 'System Locale';

class MetaLocalizationDefinition {
  final List<String> localeLanguageTags;
  final String delegateClassName;

  MetaLocalizationDefinition(
      {required this.localeLanguageTags, required this.delegateClassName});
}

class MetaLocalizationDefinitionMapper
    implements StandardMapper<MetaLocalizationDefinition> {
  @override
  MetaLocalizationDefinition fromStandardMap(Map<String, dynamic> args) =>
      MetaLocalizationDefinition(
          localeLanguageTags: List.from(args['locales'].cast<String>()),
          delegateClassName: args['delegateClassName']);

  @override
  Map<String, dynamic> toStandardMap(MetaLocalizationDefinition obj) => {
        'locales': obj.localeLanguageTags,
        'delegateClassName': obj.delegateClassName
      };
}
