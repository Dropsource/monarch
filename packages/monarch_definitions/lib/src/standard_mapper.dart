abstract class StandardMapper<T> {
  /// Implementors should return a map with keys as Strings. If the value
  /// is a list, it should be a list, not an iterable. If you have an
  /// iterable, make sure to use `.toList()` on it.
  ///
  /// This map is used by the channel's codec [StandardMethodCodec].
  Map<String, dynamic> toStandardMap(T obj);

  T fromStandardMap(Map<String, dynamic> args);
}

abstract class StandardMapperList<T> {
  /// Implementors should return a map with keys as Strings. If the value
  /// is a list, it should be a list, not an iterable. If you have an
  /// iterable, make sure to use `.toList()` on it.
  ///
  /// This map is used by the channel's codec [StandardMethodCodec].
  Map<String, dynamic> toStandardMap(List<T> list);

  List<T> fromStandardMap(Map<String, dynamic> args);
}