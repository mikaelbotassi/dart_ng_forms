import 'package:dart_ng_forms/dart_ng_forms.dart';

class ExampleForm extends FormGroup<Map<String, dynamic>> {
  ExampleForm()
      : super({
          'name': FormControl.text(initialValue: ''),
          'email': FormControl.text(initialValue: ''),
        });

  @override
  Map<String, dynamic> toModel() => value;

  @override
  fromModel(Map<String, dynamic> model) {
    setValue(model);
  }
}
