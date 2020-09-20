class EmptyLocationException implements Exception {
  final String message;
  EmptyLocationException(this.message);

  @override
  String toString() {
    return message;
  }
}
