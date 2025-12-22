import 'dart:async';
import 'package:dart_ng_forms/helpers/form_deps.dart';
import 'package:dart_ng_forms/validation/form_rules.dart';
import 'validation/validation_exception.dart';
import 'package:result_dart/result_dart.dart';
import 'form_control/form_control.dart';
import 'abstract_control.dart';

/// A reactive group of form controls.
///
/// A `FormGroup` holds a collection of [FormControl] or other nested `FormGroup`
/// instances, and provides utilities to read, set, validate and convert form data.
///
/// [M] is the type of the model this group maps to.
abstract class FormGroup<M> extends AbstractControl<Map<String, dynamic>> {

  /// The map of controls registered in this group.
  final Map<String, AbstractControl> controls;

  late final FormRules rules;
  late final FormDeps deps;

  /// Creates a [FormGroup] with the provided controls.
  FormGroup(this.controls){
    rules = FormRules(this);
    deps = FormDeps(this);
  }

  /// Registers a new [control] under the given [name].
  void register(String name, AbstractControl control) {
    controls[name] = control;
    _addListenerToControl(control);
  }

  bool _isListeningControls = false;

  /// Whether the group is currently listening to value changes in child controls.
  bool get isListeningControls => _isListeningControls;

  /// Starts listening to all child controls' value changes to notify listeners.
  void listenControls() {
    if (_isListeningControls) return;
    _isListeningControls = true;
    controls.values.forEach(_addListenerToControl);
  }

  void _addListenerToControl(AbstractControl control) {
    if (_isListeningControls) control.addListener(_onControlChanged);
    if (control is FormGroup) {
      control.listenControls();
      return;
    }
    (control as FormControl).valueNotifier.addListener(_onControlChanged);
  }

  /// Registers multiple controls at once.
  void registerAll(Map<String, AbstractControl> newControls) {
    for (final entry in newControls.entries) {
      register(entry.key, entry.value);
    }
  }

  /// Converts the form group to a model of type [M].
  FutureOr<M> toModel() {
    if (M == Map<String, dynamic>) {
      return getRawValue() as M;
    }
    throw UnsupportedError(
      'toModel() não implementado para $runtimeType. '
          'Implemente ou use FormGroup<Map<String, dynamic>>.',
    );
  }

  /// Converts the form group from a model of type [M].
  void fromModel(M model) {
    if (model is Map<String, dynamic>) {
      setValue(model, notify: false);
      refreshAll();
      notifyListeners();
      return;
    }
    throw UnsupportedError(
      'fromModel() não implementado para $runtimeType.',
    );
  }

  void _onControlChanged() => notifyListeners();

  /// Returns whether the control with [name] exists in this group.
  bool contains(String name) => controls.containsKey(name);

  /// Returns a [FormControl] with the given [name].
  ///
  /// Throws if the control does not exist or if it is a nested group.
  FormControl<T> control<T>(String name) {
    final ctrl = controls[name];
    if (ctrl == null) throw Exception('FormControl "$name" não encontrado');
    if (ctrl is FormGroup) {
      throw Exception(
          'O controle "$name" é um FormGroup, use group() para acessá-lo.');
    }
    return ctrl as FormControl<T>;
  }

  /// Recursively refreshes all controls and nested groups.
  void refreshAll(){
    for(var entry in controls.entries) {
      final control = entry.value;
      if (control is FormGroup) {
        control.refreshAll();
        continue;
      }
      (control as FormControl).refresh();
    }
  }

  /// Returns the nested [FormGroup] with the given [name].
  ///
  /// Throws if the control does not exist or is not a group.
  T group<T extends FormGroup>(String name) {
    final ctrl = controls[name];
    if (ctrl == null) throw Exception('FormGroup "$name" não encontrado');
    return ctrl as T;
  }

  /// Returns the current value of the group as a map.
  @override
  Map<String, dynamic> get value => {for (var e in controls.entries) e.key: e.value.value};

  /// Sets the values of all controls from the provided map [val].
  @override
  void setValue(Map<String, dynamic> val, {bool notify = true}) {
    for (final entry in val.entries) {
      final key = entry.key;
      if (!controls.containsKey(key)) continue;

      final ctrl = controls[key]!;
      var value = entry.value;

      if (ctrl is FormGroup) {
        if (value is Map<String, dynamic>) {
          ctrl.setValue(value, notify: notify);
          continue;
        }
        if (value == null) {
          ctrl.setValue(<String, dynamic>{}, notify: notify);
          continue;
        }
        throw ArgumentError(
          'Valor para "$key" precisa ser Map<String, dynamic> (FormGroup). '
              'Recebido: ${value.runtimeType}',
        );
      }

      ctrl.setValue(value, notify: notify);
    }

    if (notify) notifyListeners();
  }

  /// Recursively returns the raw value of all controls and nested groups.
  @override
  Map<String, dynamic> getRawValue() {
    final rawValue = <String, dynamic>{};
    for (var entry in controls.entries) {
      rawValue[entry.key] = entry.value.getRawValue();
    }
    return rawValue;
  }

  /// Recursively sets the raw value of all controls and nested groups.
  @override
  void setRawValue(Object? raw) {
    if (raw == null) return;

    if (raw is! Map<String, dynamic>) {
      throw ArgumentError(
        'FormGroup.setRawValue espera Map<String, dynamic>. Recebido: ${raw.runtimeType}',
      );
    }

    for (final entry in controls.entries) {
      entry.value.setRawValue(raw[entry.key]);
    }
  }

  /// Whether all controls in the group are valid.
  @override
  bool get valid => controls.values.every((c) => c.valid);

  /// Returns the first validation error found among the controls.
  @override
  String? get error => controls.values
      .map((c) => c.error)
      .firstWhere((e) => e != null, orElse: () => null);

  /// Marks all controls in the group as touched.
  void markAllAsTouched({bool notify = true}) {
    for (var c in controls.values) {
      if (c is FormGroup) {
        c.markAllAsTouched(notify: notify);
        continue;
      }
      (c as FormControl).markAsTouched(notify: notify);
    }
  }

  /// Marks all controls in the group as untouched.
  void markAllAsUntouched({bool notify = true}) {
    for (var c in controls.values) {
      if (c is FormGroup) {
        c.markAllAsUntouched(notify: notify);
        continue;
      }
      (c as FormControl).markAsUntouched(notify: notify);
    }
  }

  /// Validates the form group and returns a [Result].
  ///
  /// Returns a [Success] if valid or a [Failure] with [ValidationException] if not.
  AsyncResult<FormGroup<M>> validateResult() async {
    final error = this.error;
    if (error == null) {
      return Success(this);
    }
    return Failure(ValidationException(error));
  }

  /// Disposes all child controls and this group.
  @override
  void dispose() {
    rules.dispose();
    deps.dispose();
    for (var c in controls.values) {
      c.dispose();
    }
    super.dispose();
  }
}
