part of 'form_control.dart';

/// Configuration options for a [FormControl].
///
/// This class defines flags to control the behavior of the form control,
/// such as whether it is required, disabled, or readonly.
class FormControlOptions {
  /// Whether the control is marked as required.
  ///
  /// Defaults to `false`.
  bool required;

  /// Whether the control is disabled (user cannot edit).
  ///
  /// Defaults to `false`.
  bool disabled;

  /// Whether the control is readonly (user can see but not change).
  ///
  /// Defaults to `false`.
  bool readonly;

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

  /// Whether the control has been touched.
  bool touched;

  FormControlOptions({
    this.required = false,
    this.disabled = false,
    this.readonly = false,
    this.touched = false,
  });
}
