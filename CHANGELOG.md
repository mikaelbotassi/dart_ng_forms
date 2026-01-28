# Changelog

All notable changes to this project will be documented in this file.

## [1.5.14] - 2026-01-28

### Changed
- Move `valid` property implementation to `AbstractControl` and remove redundant overrides in `FormGroup` and `FormControl`.

## [1.5.13] - 2026-01-27

### Fixed
- Update `toString` in `ValidationException` to correctly include `stackTrace` when it is not null.

## [1.5.12] - 2026-01-14

### Fixed
- Add void return type to `setValue` and ensure recursive change notifications for nested `FormGroup`s.

## [1.5.11] - 2026-01-14

### Added
- Add the `listenValueOnly` option to `listenControls` to propagate only value changes.

## [1.5.10] - 2026-01-14

### Added
- Add the `listenValueOnly` option to `FormGroup` to propagate only value changes.

### Changed
- Rename `isListeningControls` to `propagateChanges` for clearer intent.

## [1.5.9] - 2026-01-14

### Added
- Extend `FormDeps` to support `FormGroup` dependencies and nested control paths.
- Add `FormGroup.nestedControl()` to resolve nested controls using dot notation (e.g., `"address.street"`).

### Changed
- Improve `FormDeps` listener management and standardize method formatting.

## [1.5.8] - 2025-12-31

### Fixed
- Add missing-key guards in `FormGroup.setRawValue()` to prevent runtime errors.

## [1.5.7] - 2025-12-23

### Added
- Add the `flatten` option to `FormGroup.getRawValue()`.

### Changed
- Improve `FormGroup.setRawValue()` behavior and consistency.

## [1.5.6] - 2025-12-23

### Changed
- Update `ToRawFunction` and `FromRawFunction` typedefs to use `Object?` instead of generic `<V>` for more flexible raw conversions.

## [1.5.5] - 2025-12-22

### Changed
- Refactor typedefs:
  - `FromRawFunction` → `FromRawFunction<T>`
  - `ToRawFunction<T>` → `ToRawFunction`

## [1.5.4] - 2025-12-22

### Added
- Add `ToRawFunction` and `FromRawFunction` typedefs to standardize conversion function signatures.

## [1.5.3] - 2025-12-22

### Changed
- Generalize `FormControl` `toRaw` / `fromRaw` typing to support broader conversion use cases.

## [1.5.2] - 2025-12-22

### Added
- Add `AbstractControl.setRawValue()` and implement it in `FormGroup` and `FormControl`.

## [1.5.1] - 2025-12-22

### Added
- Add `FormControl.getRawValue()` and `FormControl.setRawValue()`.

### Changed
- Update `FormGroup.fromModel()` and `FormGroup.toModel()` implementations for raw-value support.

## [1.5.0] - 2025-12-22

### Changed
- Refactor `FormControlOptions` to pass options directly to the `FormControl` constructor.

### Removed
- Remove `FormControlOptions` as an intermediate configuration object.

## [1.4.4] - 2025-12-22

### Added
- Add `toRaw` and `fromRaw` callbacks to convert `FormControl` values.

## [1.4.3] - 2025-12-19

### Fixed
- Initialize `FormDeps` in the `FormGroup` constructor.

## [1.4.2] - 2025-12-19

### Added
- Add readonly state management to `FormControl`.

### Changed
- Update state handling semantics for readonly controls.

## [1.4.1] - 2025-12-19

### Changed
- Optimize `FormControl` state-change methods to avoid unnecessary notifications.

## [1.4.0] - 2025-12-19

### Added
- Add `FormDeps` to support multiple dependent-field subscriptions.
- Add documentation for `TextControlBinder`, `ControlValueAccessor`, and `FormRules`.

### Removed
- Remove `disabled`, `required`, and `validators` from `ControlValueAccessor`.

## [1.3.1] - 2025-12-18

### Added
- Add `FormControl.markAsTouched()` / `markAsUntouched()`.
- Add `FormGroup.markAllAsTouched()` / `markAllAsUntouched()`.

## [1.3.0] - 2025-12-18

### Added
- Add a `touched` option to `FormControlOption`.

## [1.2.0] - 2025-12-18

### Changed
- Rename `ValueNotifier` to `ControlNotifier`.

## [1.1.1] - 2025-12-18

### Added
- Add a `refresh()` method to explicitly notify listeners.

## [1.1.0] - 2025-12-18

### Added
- Add `FormRules` for declarative and dependent-field validation.

## [1.0.0] - 2025-12-17

### Changed
- Bind the controller to `FormControl<String>` for text fields.

## [0.3.1] - 2025-12-16

### Changed
- Update `FormControl` to return a `TextEditingController` when needed.

### Deprecated
- Introduce behavior that may be unexpected in some integration scenarios.

## [0.3.0] - 2025-12-16

### Changed
- Update `FormControl` properties (`isRequired`, `isDisabled`, `isReadonly`) to notify listeners on changes.

### Deprecated
- Introduce additional notifications that may affect performance in large forms.

## [0.2.9] - 2025-12-16

### Changed
- Update `FormControl` properties (`isRequired`, `isDisabled`, `isReadonly`) to notify listeners on changes.

## [0.2.8] - 2025-12-15

### Added
- Add `TextControl` as an alias for `FormControl<TextEditingValue, String>` to simplify text-control creation.

## [0.2.7] - 2025-11-28

### Added
- Add support for registering validations in `FormControl` after creation.

## [0.2.6] - 2025-06-30

### Changed
- Revise README for clarity and structure.

## [0.2.5] - 2025-06-30

### Changed
- Revise README content, features, and examples.

## [0.2.4] - 2025-06-30

### Fixed
- Remove unused code.

## [0.2.3] - 2025-06-30

### Added
- Add full dartdoc coverage for public APIs.
- Add examples demonstrating `FormGroup`, `FormControl`, and `ControlValueAccessor`.

### Changed
- Improve documentation quality for better pub.dev discoverability.

## [0.2.2] - 2025-06-18

### Fixed
- Remove unused code.

## [0.2.1] - 2025-06-18

### Added
- Add example usage for `FormControl` and `FormGroup` in the `example` folder.

## [0.2.0] - 2025-06-18

### Added
- Integrate `TextEditingController` with `FormControl` / `FormGroup` via `ControlValueAccessor` for two-way binding.

## [0.1.1] - 2025-06-18

### Changed
- Reduce package description length.
- Update the repository URL.

## [0.1.0] - 2025-06-18

### Added
- Initial release:
  - `FormControl<T, V>` abstraction.
  - `FormGroup<T>` with nested controls support.
  - Validation and error handling.
  - `TextEditingController` integration.