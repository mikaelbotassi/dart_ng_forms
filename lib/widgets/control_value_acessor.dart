import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/material.dart';

abstract class ControlValueAcessor<T, V> extends StatelessWidget {
  final bool enabled;
  final bool required;
  final FormGroup? formGroup;
  final String? name;
  final FormFieldValidator? _validator;
  final FormControl<T, V>? _control;

  const ControlValueAcessor(
      {super.key,
      this.enabled = true,
      this.required = false,
      this.formGroup,
      this.name,
      FormControl<T, V>? control,
      FormFieldValidator? validator})
      : _validator = validator,
        _control = control;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  ChangeNotifier get changeNotifier {
    if (_control != null) return _control!;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!);
    }
    throw Exception(
        'ControlValueAcessor: model or formGroup and name must be provided');
  }

  FormControl<T, V> get control {
    if (_control != null) return _control!;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!);
    }
    throw Exception(
        'ControlValueAcessor: model or formGroup and name must be provided');
  }

  TextEditingController get textController {
    if (_control != null) return _control!.controller;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).controller;
    }
    throw Exception(
        'ControlValueAcessor: model or formGroup and name must be provided');
  }

  V get value {
    if (_control != null) return _control!.value;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).value;
    }
    throw Exception(
        'ControlValueAcessor: model or formGroup and name must be provided');
  }

  set value(V value) {
    if (_control != null) return _control!.setValue(value);
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).setValue(value);
    }
    throw Exception(
        'ControlValueAcessor: model or formGroup and name must be provided');
  }

  bool get isValid {
    if (_control != null) return _control!.valid;
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).valid;
    }
    throw Exception(
        'ControlValueAcessor: model or formGroup and name must be provided');
  }

  String? get error {
    if (_control != null) return validator?.call(_control!.value);
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).error;
    }
    throw Exception(
        'ControlValueAcessor: model or formGroup and name must be provided');
  }

  bool get isDisabled {
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).isDisabled;
    }
    return !enabled;
  }

  bool get isRequired {
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).isRequired;
    }
    return required;
  }

  FormFieldValidator? get validator {
    if (formGroup != null && name != null) {
      return formGroup!.control(name!).validator;
    }
    return _validator;
  }
}
