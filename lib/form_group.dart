import 'dart:async';
import 'exceptions/validation_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:result_dart/result_dart.dart';
import 'form_control/form_control.dart';
import 'abstract_control.dart';

abstract class FormGroup<M> extends AbstractControl<Map<String, dynamic>> {
  final Map<String, AbstractControl> controls;

  void register(String name, AbstractControl control) {
    controls[name] = control;
    _addListenerToControl(control);
  }

  bool _isListeningControls = false;
  bool get isListeningControls => _isListeningControls;

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

  FormGroup(this.controls);

  void registerAll(Map<String, AbstractControl> newControls) {
    for (final entry in newControls.entries) {
      register(entry.key, entry.value);
    }
  }

  FutureOr<M> toModel();
  fromModel(M model);

  void _onControlChanged() => notifyListeners();

  bool contains(String name) => controls.containsKey(name);

  FormControl<T, V> control<T, V>(String name) {
    final ctrl = controls[name];
    if (ctrl == null) throw Exception('FormControl "$name" não encontrado');
    if (ctrl is FormGroup) {
      throw Exception(
          'O controle "$name" é um FormGroup, use group() para acessá-lo.');
    }
    return ctrl as FormControl<T, V>;
  }

  FormControl<TextEditingValue, String> textControl(String name) {
    final ctrl = controls[name];
    if (ctrl == null) throw Exception('FormControl "$name" não encontrado');
    if (ctrl is FormGroup) {
      throw Exception(
          'O controle "$name" é um FormGroup, use group() para acessá-lo.');
    }
    return ctrl as FormControl<TextEditingValue, String>;
  }

  T group<T extends FormGroup>(String name) {
    final ctrl = controls[name];
    if (ctrl == null) throw Exception('FormGroup "$name" não encontrado');
    return ctrl as T;
  }

  @override
  Map<String, dynamic> get value =>
      {for (var e in controls.entries) e.key: e.value.value};

  @override
  void setValue(Map<String, dynamic> val) {
    val.forEach((key, v) {
      if (controls.containsKey(key)) {
        controls[key]!.setValue(v);
      }
    });
    notifyListeners();
  }

  Map<String, dynamic> getRawValue() {
    final rawValue = <String, dynamic>{};
    for (var entry in controls.entries) {
      if (entry.value is FormGroup) {
        rawValue.addAll((entry.value as FormGroup).getRawValue());
      } else {
        rawValue[entry.key] = entry.value.value;
      }
    }
    return rawValue;
  }

  @override
  bool get valid => controls.values.every((c) => c.valid);

  @override
  String? get error => controls.values
      .map((c) => c.error)
      .firstWhere((e) => e != null, orElse: () => null);

  @override
  void dispose() {
    for (var c in controls.values) {
      c.dispose();
    }
    super.dispose();
  }

  AsyncResult<FormGroup<M>> validateResult() async {
    final error = this.error;
    if (error == null) {
      return Success(this);
    }
    return Failure(ValidationException(error));
  }
}
