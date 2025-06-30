/// Configuration options for a [FormControl].
///
/// This class defines flags to control the behavior of the form control,
/// such as whether it is required, disabled, or readonly.
class FormControlOptions {
  /// Whether the control is marked as required.
  ///
  /// Defaults to `false`.
  bool isRequired;

  /// Whether the control is disabled (user cannot edit).
  ///
  /// Defaults to `false`.
  bool isDisabled;

  /// Whether the control is readonly (user can see but not change).
  ///
  /// Defaults to `false`.
  bool isReadonly;

  /// Creates a new [FormControlOptions] instance.
  ///
  /// All options default to `false` if not specified.
  ///
  /// Example:
  /// ```dart
  /// final options = FormControlOptions(
  ///   isRequired: true,
  ///   isDisabled: false,
  ///   isReadonly: false,
  /// );
  /// ```
  FormControlOptions({
    this.isRequired = false,
    this.isDisabled = false,
    this.isReadonly = false,
  });
}
