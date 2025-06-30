import 'package:flutter/material.dart';
import '../abstract_control.dart';
import 'form_control_options.dart';

/// A single reactive form control.
///
/// A `FormControl` holds a value of type [V], notifies listeners on changes,
/// and provides validation and state management (required, disabled, readonly).
///
/// It can be used with simple values or with a [TextEditingController] for text fields.
///
/// - [T] is the type stored in the [ValueNotifier].
/// - [V] is the external representation of the value.
class FormControl<T, V> extends AbstractControl<V> {
  /// The underlying value notifier holding the current value.
  final ValueNotifier<T> valueNotifier;

  /// The optional validator function to check the control's value.
  final FormFieldValidator<V>? validator;

  /// Options to configure control state (required, disabled, readonly).
  final FormControlOptions options;

  /// Creates a [FormControl] with the provided [valueNotifier], [validator], and [options].
  FormControl._({
    required this.valueNotifier,
    this.validator,
    FormControlOptions? options,
  }) : options = options ?? FormControlOptions();

  /// Creates a [FormControl] for any generic type.
  ///
  /// Example:
  /// ```dart
  /// final control = FormControl.create<int>(initialValue: 0);
  /// ```
  static FormControl<T, T> create<T>({
    required T initialValue,
    FormFieldValidator<T>? validator,
    FormControlOptions? options,
  }) {
    return FormControl<T, T>._(
      valueNotifier: ValueNotifier<T>(initialValue),
      validator: validator,
      options: options,
    );
  }

  /// Creates a [FormControl] specialized for text input.
  ///
  /// This uses [TextEditingController] internally.
  ///
  /// Example:
  /// ```dart
  /// final control = FormControl.text(initialValue: 'Hello');
  /// ```
  static FormControl<TextEditingValue, String> text({
    required String? initialValue,
    FormFieldValidator<String>? validator,
    FormControlOptions? options,
  }) {
    final controller = TextEditingController(text: initialValue);
    return FormControl<TextEditingValue, String>._(
      valueNotifier: controller,
      validator: validator,
      options: options,
    );
  }

  /// Returns the [TextEditingController] if this control manages text.
  ///
  /// Throws if not a text control.
  TextEditingController get controller {
    if (valueNotifier is TextEditingController) {
      return valueNotifier as TextEditingController;
    }
    throw Exception('FormControl<$T> does not have a TextEditingController');
  }

  /// Returns the current value of the control.
  @override
  V get value {
    if (valueNotifier is TextEditingController) {
      return (valueNotifier as TextEditingController).text as V;
    }
    return valueNotifier.value as V;
  }

  /// Sets the control value, unless disabled or readonly.
  @override
  void setValue(V val) {
    if (options.isDisabled || options.isReadonly) {
      return; // Ignore updates if disabled or readonly
    }
    if (valueNotifier is TextEditingController) {
      (valueNotifier as TextEditingController).text = val as String;
    } else {
      valueNotifier.value = val as T;
    }
    notifyListeners();
  }

  /// Whether the control is valid (no validation errors).
  @override
  bool get valid => validator?.call(value) == null;

  /// The validation error message, if any.
  @override
  String? get error => validator?.call(value);

  /// Whether the control is marked as required.
  bool get isRequired => options.isRequired;

  /// Sets whether the control is marked as required.
  set isRequired(bool v) => options.isRequired = v;

  /// Whether the control is disabled.
  bool get isDisabled => options.isDisabled;

  /// Sets whether the control is disabled.
  set isDisabled(bool v) => options.isDisabled = v;

  /// Whether the control is readonly.
  bool get isReadonly => options.isReadonly;

  /// Sets whether the control is readonly.
  set isReadonly(bool v) => options.isReadonly = v;

  /// Disposes the [ValueNotifier].
  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}