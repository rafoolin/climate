// Instead of SocketException
class NoInternetException implements Exception {
  final String message;
  NoInternetException(this.message);

  @override
  String toString() {
    return message;
  }
}
