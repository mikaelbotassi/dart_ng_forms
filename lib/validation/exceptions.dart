/// A custom exception class for handling validation errors in DartNgForms.
class DartNgFormsException implements Exception{

  /// A message describing the validation error.
  final String message;
  /// Optional stack trace associated with where the error occurred.
  final StackTrace? stackTrace;

  /// Creates a [DartNgFormsException] with a [message] describing the issue.
  ///
  /// Optionally, you can provide a [stackTrace].
  ///
  /// Example:
  /// ```dart
  /// throw DartNgFormsException('Field "name" cannot be empty');
  /// ```
  DartNgFormsException(this.message, [this.stackTrace]);

  @override
  String toString() {
    if(stackTrace != null){
      return '$runtimeType: $message\n$stackTrace';
    }
    return '$runtimeType: $message';
  }

}

/// Exception thrown when a validation error occurs.
///
/// Use this exception to indicate that some input or form data
/// failed validation checks.
class ValidationException extends DartNgFormsException {
  ValidationException(super.message, [super.stackTrace]);
}