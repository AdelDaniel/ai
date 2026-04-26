# Deep Night Theme Guide

The "Deep Night" theme is designed for low-light environments, prioritizing eye comfort and a premium aesthetic. This guide covers the complete theming architecture, including usage, customization, and state management.

## 1. Architecture Overview

The theming system is modular and layered:

*   **`AppThemeFactory`** (`lib/core/theme/app_theme_factory.dart`): The entry point for building `ThemeData`. It orchestrates the `BaseAppTheme` implementation and `TextThemeBuilder` based on the current `ThemeMode` and `Locale`.
*   **`BaseAppTheme`** (`lib/core/theme/themes/base_app_theme.dart`): An abstract interface defining the contract for all app themes (Light, Dark, High Contrast, etc.).
*   **`MainAppTheme`** (`lib/core/theme/themes/main_app_theme.dart`): The concrete implementation of `BaseAppTheme` providing the "Deep Night" style.
*   **`TextThemeBuilder`** (`lib/core/theme/text_theme/text_theme_builder.dart`): A utility class that applies the custom font family (Inter) to standard Material text styles.
*   **`ThemeConstants`** (`lib/core/theme/theme_constants.dart`): Centralized constants for design tokens like border radius, elevation, and font sizes.
*   **`ThemeModeCubit`** (`lib/core/theme/cubit/theme_mode_cubit.dart`): Manages the dynamic switching of `ThemeMode` (Light, Dark, System).

## 2. Color Palette

*   **Midnight Blue (`0xFF1A2238`)**: Primary background. Deepest shade.
*   **Deep Space (`0xFF0F172A`)**: Secondary background. Slightly lighter than Midnight Blue.
*   **Periwinkle (`0xFF9DAAF2`)**: Primary accent. Used for interactive elements.
*   **Soft Gold (`0xFFFFD700`)**: Secondary accent. Premium/High-value items.
*   **Text Primary (`0xFFF5F5F5`)**: High emphasis text.
*   **Text Secondary (`0xFF8E9775`)**: Medium emphasis text.

## 3. Typography

We use **Inter** via `google_fonts`. The scale follows Material Design 3 but is customized for our specific aesthetic.

*   `displayLarge`: 57px, Light (w300)
*   `headlineLarge`: 32px, Regular (w400)
*   `titleMedium`: 16px, Medium (w500)
*   `bodyLarge`: 16px, Regular (w400)
*   `labelLarge`: 14px, SemiBold (w600)

## 4. Usage in Code

### Accessing Theme & Colors

Always use the standard `context.` or the `BuildContext` extensions provided in `core/extensions/extensions.dart`.

**DO NOT** use `extensions_lover` imports directly. Import `package:hush/core/extensions/extensions.dart`.


### Accessing Text Styles

Use the shorthand extensions on `BuildContext` for clean, readable code.

```dart
import 'package:hush/core/theme/theme.dart';

Text(
  "Hello World",
  style: context.displayLarge,
)

Text(
  "Secondary Info",
  style: context.bodyMedium?.copyWith(color: context.colorScheme.secondary),
)
```

### Changing the Theme

Use the `ThemeModeCubit` to switch themes dynamically.

```dart
import 'package:hush/core/theme/cubit/theme_mode_cubit.dart';

// Toggle to Dark Mode
context.themeModeCubit.changeTheme(ThemeMode.dark);

// Check current mode
if (context.currentThemeMode == ThemeMode.dark) {
  // ...
}
```

### Glassmorphism

For frosted glass effects, use the pre-defined constants in `AppTheme`.

```dart
Container(
  decoration: BoxDecoration(
    color: AppTheme.glassSurface,
    border: Border.all(color: AppTheme.glassBorder),
  ),
)
```

## 5. Adding New Themes

To add a completely new visual style (e.g., a "Daylight" theme):

1.  Create a new class implementing `BaseAppTheme` (e.g., `DaylightAppTheme`).
2.  Implement all required getters and methods, defining your new color schemes and component themes.
3.  Update `AppThemeFactory` to use your new theme class based on logic (e.g., a new configuration setting or feature flag).
