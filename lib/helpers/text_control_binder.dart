import 'package:dart_ng_forms/dart_ng_forms.dart';
import 'package:flutter/widgets.dart';

/// Keeps a [FormControl<String>] and a [TextEditingController] in sync.
///
/// Why this exists:
/// - Flutter text inputs are typically driven by a [TextEditingController].
/// - `dart_ng_forms` exposes values via [FormControl.value] / [valueNotifier].
/// This binder bridges both worlds, ensuring:
/// - User typing updates the control value.
/// - Programmatic control updates reflect in the text field.
///
/// It also prevents infinite update loops by using an internal `_syncing` guard.
class TextControlBinder {
  /// The reactive form control that represents the source of truth for text.
  final FormControl<String> control;

  /// The controller used by Flutter [TextField]/[TextFormField].
  final TextEditingController controller;

  /// Internal guard to avoid feedback loops:
  /// controller -> control -> controller -> ...
  bool _syncing = false;

  /// Creates a new binder and immediately wires the two-way synchronization.
  ///
  /// On initialization:
  /// 1) The controller is updated to match the current [control.value].
  /// 2) Listeners are attached:
  ///    - controller listener propagates user edits to the control.
  ///    - control listener propagates programmatic updates back to the controller.
  TextControlBinder({
    required this.control,
    required this.controller,
  }) {
    // Initialize the controller with the current control value.
    // We don't preserve selection on first set because there is no meaningful
    // cursor state to keep yet.
    _setControllerText(control.value, preserveSelection: false);

    // When the user types (controller changes), update the form control.
    controller.addListener(_onControllerChanged);

    // When the form control changes programmatically, update the controller text.
    control.valueNotifier.addListener(_onControlChanged);
  }

  /// Handles changes coming from the Flutter text controller.
  ///
  /// - Skips updates while we are already syncing from the control side.
  /// - Avoids redundant updates when values are already equal.
  /// - Writes the controller text into the control via [control.setValue].
  void _onControllerChanged() {
    if (_syncing) return;

    final text = controller.text;
    if (text == control.value) return;

    _syncing = true;
    _setControlValue(text);
    _syncing = false;
  }

  /// Handles changes coming from the form control.
  ///
  /// - Skips updates while we are already syncing from the controller side.
  /// - Avoids redundant updates when values are already equal.
  /// - Updates the controller while preserving cursor/selection where possible.
  void _onControlChanged() {
    if (_syncing) return;

    final value = control.value;
    if (value == controller.text) return;

    _syncing = true;
    _setControllerText(value, preserveSelection: true);
    _syncing = false;
  }

  /// Writes a new value to the form control.
  ///
  /// This is separated for clarity and future extension (e.g., silent updates).
  void _setControlValue(String value) {
    control.setValue(value);
  }

  /// Updates the controller text.
  ///
  /// If [preserveSelection] is false:
  /// - Uses `controller.text = ...`, which resets selection/cursor state.
  ///
  /// If [preserveSelection] is true:
  /// - Preserves the previous cursor location as much as possible by clamping it
  ///   to the new text length.
  /// - Clears composing range to avoid invalid IME composing states.
  void _setControllerText(String text, {required bool preserveSelection}) {
    if (!preserveSelection) {
      controller.text = text;
      return;
    }

    final old = controller.value;
    final selection = old.selection;

    // Clamp the cursor position so it never exceeds the new text bounds.
    final newOffset = selection.baseOffset.clamp(0, text.length);

    controller.value = old.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: newOffset),
      composing: TextRange.empty,
    );
  }

  /// Disposes this binder by detaching all listeners.
  ///
  /// Call this from your widget/form lifecycle to prevent memory leaks.
  /// Note: This does NOT dispose the [controller] nor the [control] themselves;
  /// ownership remains with whoever created them.
  void dispose() {
    controller.removeListener(_onControllerChanged);
    control.valueNotifier.removeListener(_onControlChanged);
  }
}