# dart_ng_forms

A lightweight, Flutter-friendly reactive forms toolkit focused on **clean APIs**, **predictable state**, and **cross-field orchestration**—without turning your codebase into a soap opera.

This package provides `FormControl` and `FormGroup` primitives, plus helpers to:
- bind `TextEditingController` cleanly,
- compose validators fluently (including dependent fields),
- react to changes across multiple controls (side-effects),
- manage `touched` state consistently,
- and keep UI updates deterministic via notifiers/refresh.

> Built to play nicely with modern Flutter apps (MVVM-friendly, dependency injection-friendly, and “no surprises in production” friendly).

---

## Key Features

### ✅ Reactive primitives
- **`FormControl<T>`**: holds value, validator, error, flags (`disabled`, `required`, `touched`), and notifies listeners.
- **`FormGroup`**: aggregates controls (including nested groups), exposes control lookup, and supports bulk operations.

### ✅ First-class UX state
- `touched` support on `FormControl` and bulk APIs on `FormGroup`:
    - `markAsTouched()` / `markAsUntouched()`
    - `markAllAsTouched()` / `markAllAsUntouched()`

### ✅ Clean UI binding (text inputs)
- Built-in **`TextEditingController` integration** for string controls.
- `TextControlBinder` keeps the controller and the control synchronized safely:
    - avoids infinite loops,
    - preserves cursor/selection as much as possible.

### ✅ Declarative validation + dependent fields
- `FormRules` lets you:
    - compose multiple validators,
    - re-run validation when other controls change (`dependsOn` / `dependsOnAll`).

### ✅ Multi-control change orchestration (side-effects)
- `FormDeps` (or your equivalent helper) lets you run arbitrary callbacks when one or more controls change—perfect for:
    - enabling/disabling fields,
    - clearing values,
    - recalculating derived fields,
    - triggering business rules.

### ✅ Developer Experience
- Strong runtime errors for missing bindings (no silent failures).
- Easy disposal patterns to prevent memory leaks.
- Lean, readable code that won’t trigger a refactor committee.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dart_ng_forms: ^YOUR_VERSION
