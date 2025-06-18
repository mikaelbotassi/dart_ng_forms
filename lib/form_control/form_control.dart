import 'package:flutter/material.dart';
import '../abstract_control.dart';
import 'form_control_options.dart';

class FormControl<T, V> extends AbstractControl<V> {
  final ValueNotifier<T> valueNotifier;
  final FormFieldValidator<V>? validator;
  final FormControlOptions options;

  FormControl._({
    required this.valueNotifier,
    this.validator,
    FormControlOptions? options,
  }) : options = options ?? FormControlOptions();

  static FormControl<T, T> create<T>({
    required T initialValue,
    FormFieldValidator<T>? validator,
    FormControlOptions? options,
  }) {
    return FormControl<T, T>._(
      valueNotifier: ValueNotifier<T>(initialValue),
      validator: validator,
      options: options,
    );
  }

  static FormControl<TextEditingValue, String> text({
    required String? initialValue,
    FormFieldValidator<String>? validator,
    FormControlOptions? options,
  }) {
    final controller = TextEditingController(text: initialValue);
    return FormControl<TextEditingValue, String>._(
      valueNotifier: controller,
      validator: validator,
      options: options,
    );
  }

  TextEditingController get controller {
    if (valueNotifier is TextEditingController) {
      return valueNotifier as TextEditingController;
    }
    throw Exception('FormControl<$T> não possui TextEditingController');
  }

  @override
  V get value {
    if (valueNotifier is TextEditingController) {
      return (valueNotifier as TextEditingController).text as V;
    }
    return valueNotifier.value as V;
  }

  @override
  void setValue(V val) {
    if (options.isDisabled || options.isReadonly) {
      return; // Não permite alteração se estiver desabilitado ou somente leitura
    }
    if (valueNotifier is TextEditingController) {
      (valueNotifier as TextEditingController).text = val as String;
    } else {
      valueNotifier.value = val as T;
    }
    notifyListeners();
  }

  @override
  bool get valid => validator?.call(value) == null;

  @override
  String? get error => validator?.call(value);

  bool get isRequired => options.isRequired;
  set isRequired(bool v) => options.isRequired = v;

  bool get isDisabled => options.isDisabled;
  set isDisabled(bool v) => options.isDisabled = v;

  bool get isReadonly => options.isReadonly;
  set isReadonly(bool v) => options.isReadonly = v;

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}
