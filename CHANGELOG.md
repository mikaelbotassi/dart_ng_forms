# Changelog

All notable changes to this project will be documented in this file.

## [1.5.12] - 2026-01-14

### Fixed

* Added void return type to setValue and ensure recursive change notifications for nested FormGroups.

## [1.5.11] - 2026-01-14

### Changed

* Added the `listenValueOnly` option to `listenControls` function to propagate only value changes.

## [1.5.10] - 2026-01-14

### Added

* Added the `listenValueOnly` option to `FormGroup` to propagate only value changes.

### Changed

* Renamed `isListeningControls` to `propagateChanges` for clearer intent.

## [1.5.9] - 2026-01-14

### Added

* Extended `FormDeps` to support `FormGroup` dependencies and nested control paths.

### Changed

* Improved `FormDeps` listener management and standardized method formatting.

### Added

* Added `FormGroup.nestedControl()` to resolve nested controls using dot notation (e.g., `"address.street"`).

## [1.5.8] - 2025-12-31

### Fixed

* Added missing-key guards in `FormGroup.setRawValue()` to prevent runtime errors.

## [1.5.7] - 2025-12-23

### Added

* Added the `flatten` option to `FormGroup.getRawValue()`.

### Changed

* Improved `FormGroup.setRawValue()` behavior and consistency.

## [1.5.6] - 2025-12-23

### Changed

* Updated `ToRawFunction` and `FromRawFunction` typedefs to use `Object?` instead of generic `<V>` for more flexible raw conversions.

## [1.5.5] - 2025-12-22

### Changed

* Refactored typedefs:

    * `FromRawFunction` → `FromRawFunction<T>`
    * `ToRawFunction<T>` → `ToRawFunction`

## [1.5.4] - 2025-12-22

### Added

* Added `ToRawFunction` and `FromRawFunction` typedefs to standardize conversion function signatures.

## [1.5.3] - 2025-12-22

### Changed

* Generalized `FormControl` `toRaw` / `fromRaw` typing to support broader conversion use cases.

## [1.5.2] - 2025-12-22

### Added

* Added `AbstractControl.setRawValue()` and implemented it in `FormGroup` and `FormControl`.

## [1.5.1] - 2025-12-22

### Added

* Added `FormControl.getRawValue()` and `FormControl.setRawValue()`.

### Changed

* Updated `FormGroup.fromModel()` and `FormGroup.toModel()` implementations for raw-value support.

## [1.5.0] - 2025-12-22

### Changed

* Refactored `FormControlOptions` to pass options directly to the `FormControl` constructor.

### Breaking

* `FormControlOptions` is no longer used as an intermediate configuration object.

## [1.4.4] - 2025-12-22

### Added

* Added `toRaw` and `fromRaw` callbacks to convert `FormControl` values.

## [1.4.3] - 2025-12-19

### Fixed

* Initialized `FormDeps` in the `FormGroup` constructor.

## [1.4.2] - 2025-12-19

### Added

* Added readonly state management to `FormControl`.

### Breaking

* Updated state handling semantics for readonly controls.

## [1.4.1] - 2025-12-19

### Changed

* Optimized `FormControl` state-change methods to avoid unnecessary notifications.

### Breaking

* Notification behavior may differ for some state updates (pristine/dirty, touched, etc.).

## [1.4.0] - 2025-12-19

### Removed

* Removed `disabled`, `required`, and `validators` from `ControlValueAccessor`.

### Added

* Added `FormDeps` to support multiple dependent-field subscriptions.
* Added documentation for `TextControlBinder`, `ControlValueAccessor`, and `FormRules`.

### Breaking

* `ControlValueAccessor` no longer manages disabled/required/validators.

## [1.3.1] - 2025-12-18

### Added

* Added `FormControl.markAsTouched()` / `markAsUntouched()`.
* Added `FormGroup.markAllAsTouched()` / `markAllAsUntouched()`.

## [1.3.0] - 2025-12-18

### Added

* Added a `touched` option to `FormControlOption`.

## [1.2.0] - 2025-12-18

### Changed

* Renamed `ValueNotifier` to `ControlNotifier`.

## [1.1.1] - 2025-12-18

### Added

* Added a `refresh()` method to explicitly notify listeners.

## [1.1.0] - 2025-12-18

### Added

* Added `FormRules` for declarative and dependent-field validation.

## [1.0.0] - 2025-12-17

### Changed

* Bound the controller to `FormControl<String>` for text fields.

### Breaking

* Controller binding now requires `FormControl<String>`.

## [0.3.1] - 2025-12-16

### Changed

* Updated `FormControl` to return a `TextEditingController` when needed.

### Deprecated/Problematic

* This release introduced behavior that may be unexpected in some integration scenarios.

## [0.3.0] - 2025-12-16

### Changed

* Updated `FormControl` properties (`isRequired`, `isDisabled`, `isReadonly`) to notify listeners on changes.

### Deprecated/Problematic

* This release introduced additional notifications that may affect performance in large forms.

## [0.2.9] - 2025-12-16

### Changed

* Updated `FormControl` properties (`isRequired`, `isDisabled`, `isReadonly`) to notify listeners on changes.

## [0.2.8] - 2025-12-15

### Added

* Added `TextControl` as an alias for `FormControl<TextEditingValue, String>` to simplify text-control creation.

## [0.2.7] - 2025-11-28

### Added

* Added support for registering validations in `FormControl` after creation.

## [0.2.6] - 2025-06-30

### Changed

* Revised README for clarity and structure.

## [0.2.5] - 2025-06-30

### Changed

* Revised README content, features, and examples.

## [0.2.4] - 2025-06-30

### Fixed

* Removed unused code.

## [0.2.3] - 2025-06-30

### Added

* Added full dartdoc coverage for public APIs.
* Added examples demonstrating `FormGroup`, `FormControl`, and `ControlValueAccessor`.

### Changed

* Improved documentation quality for better pub.dev discoverability.

## [0.2.2] - 2025-06-18

### Fixed

* Removed unused code.

## [0.2.1] - 2025-06-18

### Added

* Added example usage for `FormControl` and `FormGroup` in the `example` folder.

## [0.2.0] - 2025-06-18

### Added

* Integrated `TextEditingController` with `FormControl` / `FormGroup` via `ControlValueAccessor` for two-way binding.

## [0.1.1] - 2025-06-18

### Changed

* Reduced package description length.
* Updated the repository URL.

## [0.1.0] - 2025-06-18

### Added

* Initial release:

    * `FormControl<T, V>` abstraction.
    * `FormGroup<T>` with nested controls support.
    * Validation and error handling.
    * `TextEditingController` integration.