import 'package:dart_ng_forms/helpers/text_control_binder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../abstract_control.dart';

part 'form_control_options.dart';
part 'control_value.dart';

typedef ToRawFunction<T,V> = V Function(T value);
typedef FromRawFunction<T,V> = T Function(V raw);

/// A single reactive form control.
///
/// A `FormControl` holds a value of type [V], notifies listeners on changes,
/// and provides validation and state management (required, disabled, readonly).
///
/// It can be used with simple values or with a [TextEditingController] for text fields.
///
/// - [T] is the type stored in the [ValueNotifier].
class FormControl<T> extends AbstractControl<T> {

  TextControlBinder? _controllerBinder;

  final ToRawFunction? toRaw;
  final FromRawFunction? fromRaw;

  /// The underlying value notifier holding the current value.
  final ControlValue<T> valueNotifier;

  /// The optional validator function to check the control's value.
  FormFieldValidator<T>? validator;

  /// Options to configure control state (required, disabled, readonly).
  final FormControlOptions options;

  /// Creates a [FormControl] with the provided [valueNotifier], [validator], and [options].
  FormControl({
    required T initialValue,
    this.validator,
    bool required = false,
    bool disabled = false,
    bool readonly = false,
    bool touched = false,
    this.fromRaw,
    this.toRaw,
  }) : options = FormControlOptions(
    required:required,
    disabled:disabled,
    readonly:readonly,
    touched:touched,
  ), valueNotifier = ControlValue<T>(initialValue);

  /// Returns the current value of the control.
  @override
 T get value {
    return valueNotifier.value ;
  }

  /// Returns the raw value of the control.
  @override
  Object? getRawValue() => toRaw != null ? toRaw!(value) : value;

  /// Sets the raw value of the control.
  @override
  void setRawValue(Object? value){
    setValue(fromRaw != null ? fromRaw!(value) : value as T);
  }

  /// Sets the control value, unless disabled or readonly.
  @override
  void setValue(T val, {bool notify = true}) {
    if (options.disabled || options.readonly) {
      return;
    }
    valueNotifier.setValue(val, notify: notify);
    if(notify) notifyListeners();
  }

  /// Whether the control is valid (no validation errors).
  @override
  bool get valid => validator?.call(value) == null;

  /// The validation error message, if any.
  @override
  String? get error => validator?.call(value);

  /// Whether the control is marked as required.
  bool get required => options.required;

  /// Sets whether the control is marked as required.
  void setRequired(bool v, {bool notify = true}){
    if(options.required == v) return;
    options.required = v;
    if(notify) notifyListeners();
  }

  /// Whether the control is disabled.
  bool get disabled => options.disabled;

  /// Sets whether the control is disabled.
  void setDisabled(bool v, {bool notify = true}){
    if(options.disabled == v) return;
    options.disabled = v;
    if(notify) notifyListeners();
  }

  /// Whether the control is readonly.
  bool get readonly => options.readonly;

  /// Sets whether the control is readonly.
  void setReadonly(bool v, {bool notify = true}){
    if(options.readonly == v) return;
    options.readonly = v;
    if(notify) notifyListeners();
  }

  /// Updates the validator function.
  /// @param newValidator The new validator function to set.
  void setValidator(FormFieldValidator<T>? newValidator, {bool notify = true}) {
    validator = newValidator;
    if(notify) notifyListeners();
  }

  TextEditingController get controller {
    if (this is! FormControl<String>) {
      throw UnsupportedError('controller only supports FormControl<String>');
    }

    _controllerBinder ??= TextControlBinder(
      control: this as FormControl<String>,
      controller: TextEditingController(text: (this as FormControl<String>).value),
    );

    return _controllerBinder!.controller;
  }

  /// Whether the control has been touched.
  bool get touched => options.touched;

  void markAsTouched({bool notify = true}) {
    if(options.touched) return;
    options.touched = true;
    if(notify) notifyListeners();
  }

  void markAsUntouched({bool notify = true}) {
    if(!options.touched) return;
    options.touched = false;
    if(notify) notifyListeners();
  }

  void refresh(){
    notifyListeners();
    valueNotifier.refresh();
  }

  /// Disposes the [ValueNotifier].
  @override
  void dispose() {
    _controllerBinder?.dispose();
    _controllerBinder = null;
    valueNotifier.dispose();
    super.dispose();
  }
}