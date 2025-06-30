import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/material.dart';

/// An abstract base class to build custom form input widgets that connect
/// a [FormControl] or a [FormGroup] to the widget tree.
///
/// This is inspired by Angular's `ControlValueAccessor`, providing a clean
/// interface to bind reactive controls to Flutter widgets.
///
/// Use this class as a base for widgets that need to:
/// - Read and write values to/from a [FormControl].
/// - Integrate with validation and disabled/read-only state.
/// - Listen to changes in the form control's state.
///
/// Example usage:
/// ```dart
/// class CustomInput extends ControlValueAcessor<String, String> {
///   const CustomInput({super.key, required super.formGroup, required super.name});
///
///   @override
///   Widget build(BuildContext context) {
///     return TextField(
///       controller: textController,
///       decoration: InputDecoration(errorText: error),
///       onChanged: (val) => value = val,
///     );
///   }
/// }
/// ```
abstract class ControlValueAcessor<T, V> extends StatelessWidget {
  /// Whether this field is enabled.
  final bool enabled;

  /// Whether this field is required.
  final bool required;

  /// The [FormGroup] this accessor binds to (if using a named control).
  final FormGroup? formGroup;

  /// The name of the control inside the [FormGroup].
  final String? name;

  /// The validator function for this control.
  final FormFieldValidator? _validator;

  /// The [FormControl] instance, if passed directly.
  final FormControl<T, V>? _control;

  /// Creates a [ControlValueAcessor].
  ///
  /// You must provide either:
  /// - [control], or
  /// - [formGroup] and [name].
  const ControlValueAcessor({
    super.key,
    this.enabled = true,
    this.required = false,
    this.formGroup,
    this.name,
    FormControl<T, V>? control,
    FormFieldValidator? validator,
  })  : _validator = validator,
        _control = control;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  /// Returns the [ChangeNotifier] associated with this control.
  ///
  /// Throws if neither [control] nor [formGroup]+[name] were provided.
  ChangeNotifier get changeNotifier {
    if (_control != null) return _control!;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!);
    }
    throw Exception(
      'ControlValueAcessor: control or formGroup and name must be provided',
    );
  }

  /// Returns the [FormControl] for this accessor.
  ///
  /// Throws if neither [control] nor [formGroup]+[name] were provided.
  FormControl<T, V> get control {
    if (_control != null) return _control!;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!);
    }
    throw Exception(
      'ControlValueAcessor: control or formGroup and name must be provided',
    );
  }

  /// Returns the [TextEditingController] if this control is a text control.
  ///
  /// Throws if not a text control.
  TextEditingController get textController {
    if (_control != null) return _control!.controller;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).controller;
    }
    throw Exception(
      'ControlValueAcessor: control or formGroup and name must be provided',
    );
  }

  /// Returns the current value of this control.
  ///
  /// Throws if neither [control] nor [formGroup]+[name] were provided.
  V get value {
    if (_control != null) return _control!.value;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).value;
    }
    throw Exception(
      'ControlValueAcessor: control or formGroup and name must be provided',
    );
  }

  /// Updates the value of this control.
  ///
  /// Throws if neither [control] nor [formGroup]+[name] were provided.
  set value(V value) {
    if (_control != null) return _control!.setValue(value);
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).setValue(value);
    }
    throw Exception(
      'ControlValueAcessor: control or formGroup and name must be provided',
    );
  }

  /// Whether this control is currently valid.
  bool get isValid {
    if (_control != null) return _control!.valid;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).valid;
    }
    throw Exception(
      'ControlValueAcessor: control or formGroup and name must be provided',
    );
  }

  /// Returns the validation error message, if any.
  String? get error {
    if (_control != null) return validator?.call(_control!.value);
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).error;
    }
    throw Exception(
      'ControlValueAcessor: control or formGroup and name must be provided',
    );
  }

  /// Whether this control is disabled.
  bool get isDisabled {
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).isDisabled;
    }
    return !enabled;
  }

  /// Whether this control is required.
  bool get isRequired {
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).isRequired;
    }
    return required;
  }

  /// The validator function for this control.
  FormFieldValidator? get validator {
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).validator;
    }
    return _validator;
  }
}