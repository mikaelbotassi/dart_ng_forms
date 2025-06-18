# dart_ng_forms

Reactive Forms architecture in Flutter, heavily inspired by Angular's `FormGroup`/`FormControl` pattern, 
with a focus on type safety, reusability, and seamless integration with Flutter's `TextEditingController`.

## Features

- ⚙️ Strongly typed `FormControl<T, V>` and `FormGroup<T>` system
- 🔄 Two-way binding with `TextEditingController`
- ✅ Built-in validation support
- 📦 Reusable and composable control logic
- 📊 Observability through `ChangeNotifier`

## Getting Started

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  dart_ng_forms: ^0.1.0
```

Import the package:

```dart
import 'package:dart_ng_forms/dart_ng_forms.dart';
```

## Example

```dart
final loginForm = LoginFormGroup({{
  'email': FormControl.text(initialValue: ''),
  'password': FormControl.text(initialValue: ''),
}});

if (loginForm.valid) {{
  var data = loginForm.value;
}}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
