extension RemoveAll on String {
  /// Removes all occurrences of the given [pattern] in this string.
  String removeAll(Iterable<String> value) => value.fold(
        this,
        (result, element) => result.replaceAll(
          element,
          '',
        ),
      );
}
