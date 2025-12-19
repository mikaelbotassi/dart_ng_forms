import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/widgets.dart';

/// Orchestrates side-effects triggered by form control changes.
///
/// Typical usage:
/// ```dart
/// final deps = FormDeps(form);
/// deps.when(['a', 'b']).run(() {
///   // do something when a or b changes
/// });
/// ```
///
/// Call [dispose] to detach listeners and avoid leaks.
class FormDeps {
  final FormGroup form;
  final List<VoidCallback> _disposers = [];

  FormDeps(this.form);

  /// Creates a subscription builder for one or more control names.
  DepSubscription when(Iterable<String> fieldNames) =>
      DepSubscription._(this, fieldNames.toList(growable: false));

  /// Detaches all listeners registered through this instance.
  void dispose() {
    for (final d in _disposers) d();
    _disposers.clear();
  }

  void _track(VoidCallback disposer) => _disposers.add(disposer);
}

/// Fluent subscription builder returned by [FormDeps.when].
class DepSubscription {
  final FormDeps _deps;
  final List<String> _fields;

  final Set<String> _registered = {};

  DepSubscription._(this._deps, this._fields);

  /// Runs [callback] whenever ANY of the dependent fields changes.
  ///
  /// - Debounce/throttle can be added later without changing call sites.
  /// - Optionally runs once immediately via [runNow].
  DepSubscription run(
      VoidCallback callback, {
        bool runNow = false,
      }) {
    for (final name in _fields) {
      if (!_registered.add(name)) continue;

      final control = _deps.form.control<dynamic>(name);

      void handler() => callback();

      control.valueNotifier.addListener(handler);
      _deps._track(() => control.valueNotifier.removeListener(handler));
    }

    if (runNow) callback();
    return this;
  }

  /// Runs [callback] with a snapshot of the current values of the dependencies.
  ///
  /// Useful when your side-effect depends on both A and B values.
  DepSubscription runWithValues(
      void Function(Map<String, dynamic> values) callback, {
        bool runNow = false,
      }) {
    return run(() {
      final values = <String, dynamic>{};
      for (final n in _fields) {
        values[n] = _deps.form.control<dynamic>(n).value;
      }
      callback(values);
    }, runNow: runNow);
  }
}