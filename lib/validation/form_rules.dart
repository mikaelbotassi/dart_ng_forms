import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/widgets.dart';

class FormRules {
  final FormGroup form;
  final List<VoidCallback> _disposers = [];

  FormRules(this.form);

  RuleFor<T> ruleFor<T>(String fieldName) => RuleFor<T>._(this, fieldName);

  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _disposers.clear();
  }

  void _track(VoidCallback disposer) => _disposers.add(disposer);
}

class RuleFor<T> {
  final FormRules _rules;
  final String fieldName;

  final List<FormFieldValidator<T>> _validators = [];
  final Set<String> _deps = {};

  RuleFor._(this._rules, this.fieldName);

  RuleFor<T> compose(FormFieldValidator<T> validator) {
    _validators.add(validator);
    _applyValidator();
    return this;
  }

  RuleFor<T> composeAll(Iterable<FormFieldValidator<T>> validators) {
    _validators.addAll(validators);
    _applyValidator();
    return this;
  }

  RuleFor<T> dependsOn(String anotherFieldName) {
    if (!_deps.add(anotherFieldName)) return this;

    final dep = _rules.form.control<dynamic>(anotherFieldName);
    void handler() => _refreshTarget();

    dep.valueNotifier.addListener(handler);
    _rules._track(() => dep.valueNotifier.removeListener(handler));

    _refreshTarget();

    return this;
  }

  RuleFor<T> dependsOnAll(Iterable<String> fieldNames) {
    for (final f in fieldNames) {
      dependsOn(f);
    }
    return this;
  }

  void _applyValidator() {
    final target = _rules.form.control<T>(fieldName);

    target.setValidator((value) {
      for (final v in _validators) {
        final err = v(value);
        if (err != null) return err;
      }
      return null;
    });

    _refreshTarget();
  }

  void _refreshTarget() {
    final target = _rules.form.control<T>(fieldName);

    target.setValue(target.value);
  }
}
