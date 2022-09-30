


List<MetaTheme> getStandardThemes(dynamic args) {
  final themes = args['standardThemes'];
  return themes
      .map<MetaTheme>((element) => MetaTheme.fromStandardMap(element))
      .toList();
}
