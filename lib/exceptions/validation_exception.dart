class ValidationException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  ValidationException(this.message, [this.stackTrace]);

  @override
  String toString() => 'ValidationException: $message';
}