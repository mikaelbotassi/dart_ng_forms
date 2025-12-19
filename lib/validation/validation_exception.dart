/// Exception thrown when a validation error occurs.
///
/// Use this exception to indicate that some input or form data
/// failed validation checks.
class ValidationException implements Exception {
  /// A message describing the validation error.
  final String message;

  /// Optional stack trace associated with where the error occurred.
  final StackTrace? stackTrace;

  /// Creates a [ValidationException] with a [message] describing the issue.
  ///
  /// Optionally, you can provide a [stackTrace].
  ///
  /// Example:
  /// ```dart
  /// throw ValidationException('Field "name" cannot be empty');
  /// ```
  ValidationException(this.message, [this.stackTrace]);

  /// Returns a string representation of this exception.
  @override
  String toString() => 'ValidationException: $message';
}
