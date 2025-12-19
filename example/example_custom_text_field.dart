import 'package:flutter/material.dart';
import 'package:dart_ng_forms/dart_ng_forms.dart';

/// Um TextField integrado a um [FormControl].
class CustomTextField extends StatelessWidget with ControlValueAcessor<String> {

  @override
  final FormControl<String>? control;
  @override
  final bool disabled;
  @override
  final FormGroup<dynamic>? formGroup;
  @override
  final String? name;
  @override
  final bool required;
  @override
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    this.formGroup,
    this.name,
    this.required = false,
    this.control,
    this.disabled = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: changeNotifier,
      builder: (context, _) => TextFormField(
        enabled: !disabled,
        decoration: InputDecoration(
          labelText: name,
          errorText: error,
          border: const OutlineInputBorder(),
        ),
        initialValue: value,
        onChanged: (val) => setValue(val),
      ),
    );
  }
}
