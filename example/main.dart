import 'package:flutter/material.dart';

import 'example_custom_text_field.dart';
import 'example_form.dart';

class ExampleFormScreen extends StatefulWidget {
  const ExampleFormScreen({super.key});

  @override
  State<ExampleFormScreen> createState() => _ExampleFormScreenState();
}

class _ExampleFormScreenState extends State<ExampleFormScreen> {
  late ExampleForm form;

  @override
  void initState() {
    super.initState();
    form = ExampleForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reactive Form Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo Name
            CustomTextField(
              formGroup: form,
              name: 'name',
            ),
            const SizedBox(height: 16),
            // Campo Email
            CustomTextField(
              formGroup: form,
              name: 'email',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (form.valid) {
                  final data = form.toModel();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data: $data')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form inválido')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
