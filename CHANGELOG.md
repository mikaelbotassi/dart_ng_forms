# Changelog

All notable changes to this project will be documented in this file.

## [1.3.0] - 2025-12-18
### FEATURE
- Added a new 'touched' option into FormControlOption;

## [1.2.0] - 2025-12-18
### FEATURE
- Change ValueNotifier to ControlNotifier;

## [1.1.1] - 2025-12-18
### FEATURE
- Added a refresh function to notify listeners;

## [1.1.0] - 2025-12-18
### NEW FEATURE
- Add FormRules for declarative and dependent field validation

## [1.0.0] - 2025-12-17
### BREAK CHANGES
- Binder the controller with FormControl<String>

## [0.3.1] - 2025-12-16
### PROBLEMÁTIC
- Updated FormControl to return TextEditingController when needed.

## [0.3.0] - 2025-12-16
### PROBLEMÁTIC
- Updated `FormControl` properties `isRequired`, `isDisabled`, and `isReadonly` to notify listeners when their values are changed.

## [0.2.9] - 2025-12-16
### Changed
- Updated `FormControl` properties `isRequired`, `isDisabled`, and `isReadonly` to notify listeners when their values are changed.

## [0.2.8] - 2025-12-15
### Changed
- Added an alias `TextControl` for `FormControl<TextEditingValue, String>` to simplify text control creation.

## [0.2.7] - 2025-11-28
### Changed
- Added the possibility to insert new validations into FormControl after its creation.

## [0.2.6] - 2025-06-30
### Changed
- revise README for clarity and structure.
- 
## [0.2.5] - 2025-06-30
### Changed
- revise README for clarity and structure; update features and examples.

## [0.2.4] - 2025-06-30
### Changed
- Removed unused code.

## [0.2.3] - 2025-06-30
### Added
- Added complete `dartdoc` comments to all public API elements.
- Added example files demonstrating `FormGroup`, `FormControl`, and `ControlValueAccessor` usage.
### Changed
- Improved overall documentation quality for better discoverability on pub.dev.

## [0.2.2] - 2025-06-18
### Changed
- Removed unused code.

## [0.2.1] - 2025-06-18
### Added
- Added example usage for `FormControl` and `FormGroup` in the `example` folder.

## [0.2.0] - 2025-06-18
### Added
- Integrated `TextEditingController` with `FormControl` and `FormGroup` through `ControlValueAccessor` for two-way form binding.

## [0.1.1] - 2025-06-18
### Changed
- Reduced description size.
- Added the correct repository URL.

## [0.1.0] - 2025-06-18
### Added
- Initial release with:
  - `FormControl<T, V>` abstraction.
  - `FormGroup<T>` supporting nested controls.
  - Validation and error handling.
  - Integration with `TextEditingController`.