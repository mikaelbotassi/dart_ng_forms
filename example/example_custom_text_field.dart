import 'package:dart_ng_forms/widgets/control_value_acessor.dart';
import 'package:flutter/material.dart';
import 'package:dart_ng_forms/dart_ng_forms.dart';

/// Um TextField integrado a um [FormControl].
class CustomTextField extends ControlValueAcessor<TextEditingValue, String> {
  const CustomTextField({
    super.key,
    required super.formGroup,
    required super.name,
    super.required,
    super.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      enabled: !isDisabled,
      decoration: InputDecoration(
        labelText: name,
        errorText: error,
        border: const OutlineInputBorder(),
      ),
      onChanged: (val) => value = val,
    );
  }
}
