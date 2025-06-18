import 'package:flutter/foundation.dart';

abstract class AbstractControl<T> extends ChangeNotifier {
  T get value;
  bool get valid;
  String? get error;
  void setValue(T val);
}
