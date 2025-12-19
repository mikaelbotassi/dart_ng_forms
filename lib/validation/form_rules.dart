import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/widgets.dart';

/// A small fluent helper to build validation rules for controls inside a [FormGroup],
/// with support for cross-field dependencies.
///
/// Why this exists:
/// - `dart_ng_forms` allows attaching a single validator to a control.
/// - In real forms, you often need to *compose multiple validators* and also
///   *re-validate a field when other fields change* (cross-field rules).
///
/// Example:
/// ```dart
/// final rules = FormRules(form);
///
/// rules.ruleFor<String>('password')
///   .compose(notEmpty)
///   .compose(minLength8)
///   .dependsOn('username'); // re-validates password when username changes
///
/// // later...
/// rules.dispose();
/// ```
class FormRules {
  /// The form group that owns the controls.
  final FormGroup form;

  /// Stores cleanup callbacks to detach all listeners registered by this instance.
  /// This prevents memory leaks and duplicated triggers.
  final List<VoidCallback> _disposers = [];

  FormRules(this.form);

  /// Creates a fluent rule builder for the given [fieldName].
  ///
  /// The returned [RuleFor] allows:
  /// - composing multiple validators
  /// - defining dependencies that trigger a re-validation
  RuleFor<T> ruleFor<T>(String fieldName) => RuleFor<T>._(this, fieldName);

  /// Detaches all listeners registered through this instance.
  ///
  /// Call this from your form/viewmodel/widget lifecycle (e.g., `dispose`)
  /// to avoid memory leaks and stale subscriptions.
  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _disposers.clear();
  }

  /// Registers a disposer callback (internal API).
  void _track(VoidCallback disposer) => _disposers.add(disposer);
}

/// Fluent rule builder for a single control inside a [FormGroup].
///
/// It supports:
/// - composing multiple validators into one (first error wins)
/// - attaching cross-field dependencies (revalidate when other controls change)
class RuleFor<T> {
  /// Back-reference to the [FormRules] container (used for form access + disposer tracking).
  final FormRules _rules;

  /// The target field name to which the composed validator will be attached.
  final String fieldName;

  /// List of validators to be executed in order.
  /// The first validator returning a non-null error message will stop the chain.
  final List<FormFieldValidator<T>> _validators = [];

  /// Dependency set to avoid attaching duplicated listeners for the same field.
  final Set<String> _deps = {};

  RuleFor._(this._rules, this.fieldName);

  /// Adds a single [validator] to this rule chain.
  ///
  /// After adding, the composed validator is (re)applied to the target control.
  RuleFor<T> compose(FormFieldValidator<T> validator) {
    _validators.add(validator);
    _applyValidator();
    return this;
  }

  /// Adds multiple [validators] to this rule chain.
  ///
  /// After adding, the composed validator is (re)applied to the target control.
  RuleFor<T> composeAll(Iterable<FormFieldValidator<T>> validators) {
    _validators.addAll(validators);
    _applyValidator();
    return this;
  }

  /// Declares that this rule depends on another control identified by [anotherFieldName].
  ///
  /// Whenever the dependency's value changes, the target field is "refreshed",
  /// forcing re-validation and UI updates (useful for cross-field validation).
  ///
  /// Notes:
  /// - Dependencies are de-duplicated by [_deps] to prevent multiple listeners.
  /// - Listeners are tracked and removed when [FormRules.dispose] is called.
  RuleFor<T> dependsOn(String anotherFieldName) {
    // Avoid duplicated subscriptions for the same dependency.
    if (!_deps.add(anotherFieldName)) return this;

    // Listen to the dependency's value changes.
    final dep = _rules.form.control<dynamic>(anotherFieldName);

    // When the dependency changes, revalidate/refresh the target field.
    void handler() => _refreshTarget();

    dep.valueNotifier.addListener(handler);

    // Track disposer to remove the listener later.
    _rules._track(() => dep.valueNotifier.removeListener(handler));

    // Optionally refresh once immediately so the target state is consistent
    // with the current dependency values.
    _refreshTarget();

    return this;
  }

  /// Declares multiple dependencies at once.
  ///
  /// This is syntactic sugar over calling [dependsOn] repeatedly.
  RuleFor<T> dependsOnAll(Iterable<String> fieldNames) {
    for (final f in fieldNames) {
      dependsOn(f);
    }
    return this;
  }

  /// Applies the composed validator chain to the target control.
  ///
  /// The control receives a single validator that:
  /// - runs all validators in order
  /// - returns the first non-null error string
  /// - returns null if all validators pass
  void _applyValidator() {
    final target = _rules.form.control<T>(fieldName);

    target.setValidator((value) {
      for (final v in _validators) {
        final err = v(value);
        if (err != null) return err;
      }
      return null;
    });

    // Refresh so the error/valid state is recalculated after updating the validator.
    _refreshTarget();
  }

  /// Forces the target control to re-evaluate its current state.
  ///
  /// This implementation "re-sets" the current value to itself to trigger the
  /// control's notification pipeline (value + validity + UI rebuild).
  ///
  /// If your control implementation offers a dedicated `refresh()`/`revalidate()`
  /// method, prefer using it instead of `setValue(value)`.
  void _refreshTarget() {
    final target = _rules.form.control<T>(fieldName);
    target.setValue(target.value);
  }
}