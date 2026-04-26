# Localization Guide

This project uses a standard Flutter localization approach with JSON files for storing translations.

## Overview

- **Language Files**: Located in `locale/` directory (e.g., `en.json`, `ar.json`).
- **Keys Management**: All keys are defined as constants in `lib/core/localization/localization_keys.dart`.
- **UI Access**: Use the `ExtensionLocalization` on `BuildContext` to access translations easily.

## Adding New Strings

1.  **Add Key Constant**:
    Open `lib/core/localization/localization_keys.dart` and add a new static constant for your key.

    ```dart
    static const myNewString = "my_new_string";
    ```

2.  **Update JSON Files**:
    Add the key and translation to all JSON files in `locale/`.
    - `locale/en.json`:
      ```json
      "my_new_string": "My New String"
      ```
    - `locale/ar.json`:
      ```json
      "my_new_string": "نصي الجديد"
      ```

3.  **Use in UI**:
    Use `context.translate` or `context.tr` with the constant key.
    ```dart
    Text(context.translate(LocalizationKeys.myNewString))
    ```

## Best Practices

- **Always use constants**: Never hardcode string keys in widgets.
- **Keep keys semantic**: Use keys that describe the content (e.g., `login_button_text`) rather than generic names.
- **Update all languages**: When adding a new feature, ensure all supported language files are updated to prevent missing translations.
- **Restart App**: After modifying JSON files, a hot restart or full restart is often required to load the new assets.
