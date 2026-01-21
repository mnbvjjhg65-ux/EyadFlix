enum ContentType {
  movie('movie'),
  series('series'),
  unknown('unknown');

  final String value;
  const ContentType(this.value);

  factory ContentType.fromString(String? value) {
    return ContentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ContentType.unknown,
    );
  }
}

enum HandlerType {
  catalog('catalog'),
  meta('meta'),
  stream('stream'),
  subtitles('subtitles'),
  action('action');

  final String value;
  const HandlerType(this.value);

  factory HandlerType.fromString(String value) {
    return HandlerType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => HandlerType.catalog,
    );
  }
}
