import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:dart_ng_forms/form_control/control_value.dart';
import 'package:flutter/material.dart';

mixin ControlValueAcessor<T> on Widget {

  ///We Recommend to use this declaration on widgets:
  /*
  @override
  final FormControl<T, T>? control;
  @override
  final bool enabled;
  @override
  final FormGroup<dynamic>? formGroup;
  @override
  final String? name;
  @override
  final bool required;
  @override
  final FormFieldValidator<T>? validator;
  */

  bool get disabled;
  bool get required;
  FormGroup? get formGroup;
  String? get name;
  FormFieldValidator<T>? get validator;
  FormControl<T>? get control;
  ChangeNotifier get changeNotifier{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to access Change Notifier');
      }
      return true;
    }());
    if(control != null) return control!;
    return formGroup!.control<T>(name!);
  }

  ControlValue<T> get valueNotifier{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to access Value Notifier');
      }
      return true;
    }());
    if(control != null) return control!.valueNotifier;
    return formGroup!.control<T>(name!).valueNotifier;
  }

  FormControl<T> get formControl{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to access FormControl');
      }
      return true;
    }());
    if(control != null) return control!;
    return formGroup!.control<T>(name!);
  }

  T get value{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to access Value');
      }
      return true;
    }());
    if(control != null) return control!.value;
    return formGroup!.control(name!).value;
  }

  setValue(T value, {bool notify = true}){
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to set value ');
      }
      return true;
    }());
    if(control != null) return control!.setValue(value, notify: notify);
    return formGroup!.control<T>(name!).setValue(value, notify: notify);
  }

  bool get isValid{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to verify if value is valid');
      }
      return true;
    }());
    if(control != null) return control!.valid;
    return formGroup!.control(name!).valid;
  }

  String? get error{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to access error');
      }
      return true;
    }());
    if(control != null) return validator?.call(control!.value);
    return formGroup!.control(name!).error;
  }

  bool get isDisabled{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to verify if value is disabled');
      }
      return true;
    }());
    if(control != null) return control!.disabled;
    if(formGroup != null && name != null){
      return formGroup!.control(name!).disabled;
    }
    return disabled;
  }

  bool get isRequired{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to verify if value is required');
      }
      return true;
    }());
    if(formGroup != null && name != null){
      return formGroup!.control(name!).required;
    }
    return required;
  }

  FormFieldValidator<T>? get formValidator{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to access validator');
      }
      return true;
    }());
    if(formGroup != null && name != null){
      return formGroup!.control(name!).validator;
    }
    return validator;
  }

  TextEditingController get controller{
    assert((){
      if(control == null && (formGroup == null || name == null)){
        throw FlutterError('ControlValueAcessor: model or formGroup and name must be provided to access controller');
      }
      if(formControl is! FormControl<String>){
        throw FlutterError('ControlValueAcessor: controller only supports FormControl<String>');
      }
      return true;
    }());
    return formControl.controller;
  }

}