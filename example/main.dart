import 'package:flutter/material.dart';
import 'package:dart_ng_forms/dart_ng_forms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final form =
      ExampleFormGroup(ExampleModel(id: 1, status: null, description: ''));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dart_ng_forms Example',
      home: Scaffold(
        appBar: AppBar(title: Text('FormGroup Example')),
        body: Column(
          children: [
            TextField(
              controller: form.textControl('description').controller,
              decoration: InputDecoration(
                labelText: 'Description',
                errorText: form.textControl('description').error,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(form.toModel());
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleFormGroup extends FormGroup<ExampleModel> {
  ExampleFormGroup(ExampleModel model)
      : super({
          'id': FormControl.create<int>(initialValue: model.id),
          'status': FormControl.create<int?>(
            initialValue: model.status,
            validator: (value) => value == null ? 'Status is required' : null,
          ),
          'description': FormControl.text(initialValue: model.description),
        });

  @override
  void fromModel(ExampleModel model) {
    control<int, int>('id').setValue(model.id);
    control<int?, int?>('status').setValue(model.status);
    textControl('description').setValue(model.description ?? '');
  }

  @override
  ExampleModel toModel() {
    return ExampleModel(
      id: control<int, int>('id').value,
      status: control<int?, int?>('status').value,
      description: textControl('description').value.isEmpty
          ? null
          : textControl('description').value,
    );
  }
}

class ExampleModel {
  final int id;
  final int? status;
  final String? description;

  ExampleModel({required this.id, this.status, this.description});
}
