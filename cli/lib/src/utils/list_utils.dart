void trimStartIfNeeded(List list, int threshold) {
  ArgumentError.checkNotNull(list, 'lines');
  ArgumentError.checkNotNull(threshold, 'threshold');

  if (list.length > threshold) {
    list.removeRange(0, list.length - threshold);
  }
}
