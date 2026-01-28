import 'package:flutter/foundation.dart';

/// Base class for form controls and groups.
abstract class AbstractControl<T> extends ChangeNotifier {

  /// The current value of the control.
  T get value;

  /// Whether the control's current value is valid.
  bool get valid => error == null;

  /// The error message if validation failed, or `null` if valid.
  String? get error;

  /// Sets the value of the control.
  void setValue(T val, {bool notify = true});

  Object? getRawValue();

  void setRawValue(Object? value, {bool notify = true});

}
