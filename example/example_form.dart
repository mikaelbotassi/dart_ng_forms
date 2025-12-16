import 'package:dart_ng_forms/dart_ng_forms.dart';

class ExampleForm extends FormGroup<Map<String, dynamic>> {
  ExampleForm()
      : super({
          'name': FormControl(initialValue: ''),
          'email': FormControl(initialValue: ''),
        });

  @override
  Map<String, dynamic> toModel() => value;

  @override
  fromModel(Map<String, dynamic> model) {
    setValue(model);
  }
}
