abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class InvalidAddonException extends AppException {
  InvalidAddonException(String message) : super(message);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}

class ParseException extends AppException {
  ParseException(String message) : super(message);
}

class PlayerException extends AppException {
  PlayerException(String message) : super(message);
}
