# dart\_ng\_forms

**A powerful reactive forms architecture for Flutter**, inspired by Angular’s `FormGroup` / `FormControl` pattern, with a strong focus on type safety, reusability, and seamless integration with Flutter’s `TextEditingController`.

---

## ✨ Features

* **Strongly Typed Controls**
  Define `FormControl<T, V>` and `FormGroup<T>` with clear, type-safe APIs.

* **Two-Way Binding**
  Automatically synchronize form state and UI via `TextEditingController`.

* **Validation Support**
  Easily integrate validation logic and retrieve error messages.

* **Composable and Reusable**
  Compose nested form structures and reuse controls across your app.

* **Reactive Observability**
  All controls are `ChangeNotifier`s for efficient UI updates.

---

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dart_ng_forms: ^0.2.6
```

Import the package:

```dart
import 'package:dart_ng_forms/dart_ng_forms.dart';
```

---

## 💡 Quick Example

Create a form group and validate:

```dart
final loginForm = LoginFormGroup({
  'email': FormControl.text(initialValue: ''),
  'password': FormControl.text(initialValue: ''),
});

if (loginForm.valid) {
  final data = loginForm.value;
  // Process your form data
}
```

---

## 🛠 Example Project

A complete working example is available in [example/main.dart](example/main.dart).

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.