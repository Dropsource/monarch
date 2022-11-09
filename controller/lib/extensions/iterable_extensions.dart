extension FirstOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test, {E? Function()? orElse}) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return orElse != null ? orElse() : null;
  }
}
