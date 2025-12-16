import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/widgets.dart';

class TextControlBinder {
  final FormControl<String> control;
  final TextEditingController controller;

  bool _syncing = false;

  TextControlBinder({
    required this.control,
    required this.controller,
  }) {

    _setControllerText(control.value, preserveSelection: false);

    controller.addListener(_onControllerChanged);
    control.valueNotifier.addListener(_onControlChanged);
  }

  void _onControllerChanged() {
    if (_syncing) return;

    final text = controller.text;
    if (text == control.value) return;

    _syncing = true;
    _setControlValue(text);
    _syncing = false;
  }

  void _onControlChanged() {
    if (_syncing) return;

    final value = control.value;
    if (value == controller.text) return;

    _syncing = true;
    _setControllerText(value, preserveSelection: true);
    _syncing = false;
  }

  void _setControlValue(String value) {
    control.setValue(value);
  }

  void _setControllerText(String text, {required bool preserveSelection}) {
    if (!preserveSelection) {
      controller.text = text;
      return;
    }

    final old = controller.value;
    final selection = old.selection;

    final newOffset = selection.baseOffset.clamp(0, text.length);

    controller.value = old.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: newOffset),
      composing: TextRange.empty,
    );
  }

  void dispose() {
    controller.removeListener(_onControllerChanged);
    control.valueNotifier.removeListener(_onControlChanged);
  }
}