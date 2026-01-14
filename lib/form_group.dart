import 'dart:async';
import 'package:dart_ng_forms/abstract_control.dart';
import 'package:dart_ng_forms/form_control/form_control.dart';
import 'package:dart_ng_forms/helpers/helpers.dart';
import 'package:dart_ng_forms/validation/validation.dart';
import 'package:result_dart/result_dart.dart';

/// A reactive group of form controls.
///
/// A `FormGroup` holds a collection of [FormControl] or other nested `FormGroup`
/// instances, and provides utilities to read, set, validate and convert form data.
///
/// [M] is the type of the model this group maps to.
abstract class FormGroup<M> extends AbstractControl<Map<String, dynamic>> {

  /// The map of controls registered in this group.
  final Map<String, AbstractControl> controls;
  bool listenValueOnly = false;

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
    _addListenerToControl(control, listenValueOnly);
  }

  bool _propagateChanges = false;

  /// Whether the group is currently listening to value changes in child controls.
  bool get propagateChanges => _propagateChanges;

  /// Starts listening to all child controls' value changes to notify listeners.
  void listenControls(bool listenValueOnly) {
    if (_propagateChanges) return;
    _propagateChanges = true;
    this.listenValueOnly = listenValueOnly;
    for (var control in controls.values) {
      _addListenerToControl(control, listenValueOnly);
    }
  }

  void _addListenerToControl(AbstractControl control, bool listenValueOnly) {
    if(!_propagateChanges) return;
    if (control is FormGroup) {
      control.listenControls(listenValueOnly);
      control.addListener(_onControlChanged);
      return;
    }
    if (listenValueOnly) {
      (control as FormControl).valueNotifier.addListener(_onControlChanged);
      return;
    }
    control.addListener(_onControlChanged);
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
    if (ctrl == null) throw DartNgFormsException('FormControl "$name" não encontrado');
    if (ctrl is FormGroup) {
      throw DartNgFormsException(
          'O controle "$name" é um FormGroup, use group() para acessá-lo.');
    }
    return ctrl as FormControl<T>;
  }

  /// Returns the nested [FormGroup] with the given [name].
  ///
  /// Throws if the control does not exist or is not a group.
  T group<T extends FormGroup>(String name) {
    final ctrl = controls[name];
    if (ctrl == null) throw DartNgFormsException('FormGroup "$name" não encontrado');
    return ctrl as T;
  }

  /// Returns the [AbstractControl] with the given [name], supporting nested paths.
  /// E.g. "address.street" will return the "street" control inside the "address" group.
  /// Supports multiple levels of nesting.
  /// Throws if any part of the path is invalid.
  AbstractControl<T> nestedControl<T>(String name){
    if(name.contains('.')){
      final parts = name.split('.');
      AbstractControl current = this;
      for(final part in parts){
        if(current is! FormGroup) {
          throw DartNgFormsException('Invalid nested control path: "$name". Part "$part" is not a FormGroup.');
        }
        final next = current.controls[part];
        if(next == null) {
          throw DartNgFormsException('Control "$part" not found in FormGroup.');
        }
        current = next;
      }
      return current as AbstractControl<T>;
    }
    if(!contains(name)) {
      throw DartNgFormsException('Control "$name" not found in FormGroup.');
    }
    return controls[name] as AbstractControl<T>;
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

  /// Builds a raw value map for all controls in this group.
  /// When [flatten] is enabled, values from nested groups are flattened into the parent map;
  /// otherwise, the nested structure is preserved.
  @override
  Map<String, dynamic> getRawValue({bool flatten = true}) {
    final rawValue = <String, dynamic>{};
    for (var entry in controls.entries) {
      if(entry.value is FormGroup){
        final group = entry.value as FormGroup;
        if(!flatten){
          rawValue[entry.key] = group.getRawValue();
          continue;
        }
        rawValue.addAll(group.getRawValue());
        continue;
      }
      rawValue[entry.key] = entry.value.getRawValue();
    }
    return rawValue;
  }

  /// Recursively applies a raw value map to this group and its nested groups.
  ///
  /// [raw] must be a `Map<String, dynamic>` where each key matches a control name.
  /// - For nested [FormGroup] controls, the same [raw] map is forwarded so the group can
  ///   pick its own keys.
  /// - For non-group controls, only the value for the corresponding key is applied.
  ///
  /// Notification behavior:
  /// - Child controls are updated with `notify: false` to avoid cascading notifications.
  /// - When [notify] is true, this [FormGroup] notifies its listeners after each control update.
  ///   If you need to notify all controls after a bulk update, prefer calling `refreshAll()`.
  @override
  void setRawValue(Object? raw, {bool notify = true}) {
    if (raw == null) return;

    if (raw is! Map<String, dynamic>) {
      throw ArgumentError(
        'FormGroup.setRawValue espera Map<String, dynamic>. Recebido: ${raw.runtimeType}',
      );
    }

    for (final entry in controls.entries) {
      if(entry.value is FormGroup) {
        final group = entry.value as FormGroup;
        group.setRawValue(raw);
        continue;
      }
      if(!raw.containsKey(entry.key)) continue;
      entry.value.setRawValue(raw[entry.key], notify: false);
      if(notify) notifyListeners();
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
