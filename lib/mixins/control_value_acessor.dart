import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/material.dart';

mixin ControlValueAcessor<T> on Widget {

  /// Optional reference to the parent [FormGroup] that owns this control.
  ///
  /// Use this when you want to bind by name (i.e., provide [formGroup] + [name])
  /// instead of passing a [control] instance directly.
  FormGroup? get formGroup;

  /// Optional control identifier inside [formGroup].
  ///
  /// Required when [control] is not provided. This is the lookup key used by
  /// [FormGroup.control] to resolve the actual [FormControl] instance.
  String? get name;

  /// Optional direct reference to a [FormControl].
  ///
  /// Prefer providing [control] when you already have the control instance at hand.
  /// If [control] is null, this accessor will attempt to resolve the control from
  /// [formGroup] + [name].
  FormControl<T>? get control;

  /// Resolves the underlying [FormControl] used by this widget/accessor.
  ///
  /// This getter centralizes the binding logic and guarantees a non-null control:
  /// - If [control] is provided, it is returned immediately.
  /// - Otherwise, [formGroup] and [name] must be provided and are used to locate
  ///   the control via [FormGroup.control].
  ///
  /// Throws a [FlutterError] when neither [control] nor ([formGroup] + [name]) are
  /// provided. This is a *runtime* guarantee (works in both debug and release),
  /// ensuring downstream getters never operate on a missing binding.
  FormControl<T> get formControl {
    if (control != null) return control!;

    final (g, n) = (formGroup, name);

    if (g == null || n == null) {
      throw FlutterError(
        'ControlValueAcessor: control or (formGroup and name) must be provided',
      );
    }
    return g.control<T>(n);
  }

  /// A [ChangeNotifier] suitable for UI rebuild triggers.
  ///
  /// In practice, [FormControl] implements [ChangeNotifier], so listening to this
  /// notifier will rebuild whenever the control emits changes (value, state, etc.).
  ChangeNotifier get changeNotifier => formControl;

  /// Low-level value notifier for the control.
  ///
  /// Useful when you need to react specifically to value changes. Prefer
  /// [changeNotifier] when you want to rebuild on any control state change.
  ControlValue<T> get valueNotifier => formControl.valueNotifier;

  /// Current control value.
  T get value => formControl.value;

  /// Updates the control value.
  ///
  /// When [notify] is true (default), listeners will be notified and reactive UI
  /// will update. When false, the value is updated silently according to the
  /// control implementation (useful for internal state sync).
  void setValue(T value, {bool notify = true}) =>
      formControl.setValue(value, notify: notify);

  /// Whether the control is currently valid.
  ///
  /// Typically derived from running [validator] against the current [value] and/or
  /// internal state.
  bool get valid => formControl.valid;

  /// Current validation error message, if any.
  ///
  /// `null` means "no error". This is the primary source for rendering error
  /// messages in custom reactive inputs (recommended over Flutter's FormField cache).
  String? get error => formControl.error;

  /// Whether the control is disabled.
  ///
  /// Disabled controls should not accept user input and typically do not display
  /// validation errors.
  bool get disabled => formControl.disabled;

  /// Whether the control is required.
  ///
  /// This flag is a semantic hint used by UI/validators to indicate mandatory input.
  bool get required => formControl.required;

  /// Validator used by the control (if any).
  ///
  /// Returns `null` when no validator is attached.
  FormFieldValidator<T>? get validator => formControl.validator;

  /// Text controller bound to this control (String-only).
  ///
  /// This assumes [formControl] exposes a [TextEditingController] (commonly for
  /// `FormControl<String>`). Use carefully if `T` can be non-String.
  TextEditingController get controller => formControl.controller;

  /// Whether the user has interacted with the control.
  ///
  /// Commonly used to decide when to show validation errors (e.g., only after touch).
  bool get touched => formControl.touched;

  /// Marks the control as "touched".
  ///
  /// When [notify] is true, listeners will be notified so the UI can update (e.g.,
  /// show errors after first interaction).
  void markAsTouched({bool notify = true}) {
    formControl.markAsTouched(notify: notify);
  }

  /// Marks the control as "untouched".
  ///
  /// Useful when resetting form state or when you want to hide validation errors
  /// until the next user interaction.
  void markAsUntouched({bool notify = true}) {
    formControl.markAsUntouched(notify: notify);
  }

}
