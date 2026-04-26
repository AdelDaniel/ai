# Routing Guide

This project uses `go_router` with centralized route definitions in `app_routes.dart` and wiring in `app_routing.dart`.

## Files of Record

- `lib/core/routes/app_routes.dart`: Route enum, route registration, and navigation helpers.
- `lib/core/routes/app_routing.dart`: Global `GoRouter` configuration.

## Add a New Screen Route

1. **Import the screen** in `app_routes.dart`.
2. **Add a new enum entry** to `AppRoutes` with a unique name and path.
3. **Register the route** in `appRoutes` (static or dynamic).
4. **Add navigation helpers** in the `AppNavigation` extension.

### Example (Static Screen)

```dart
// 1) import
import 'package:hush/features/profile/screens/profile_screen.dart';

// 2) enum entry
enum AppRoutes {
  profileScreen(name: 'Profile', path: '/profile'),
  // ...
}

// 3) register
final List<AppRoute> appRoutes = [
  AppRoute.static(
    appRoute: AppRoutes.profileScreen,
    screenWidget: const ProfileScreen(),
  ),
];

// 4) helpers
extension AppNavigation on BuildContext {
  void goToProfileScreen() => goNamed(AppRoutes.profileScreen.name);
  void pushProfileScreen() => pushNamed(AppRoutes.profileScreen.name);
}
```

### Example (Dynamic Screen)

```dart
AppRoute.dynamic(
  appRoute: AppRoutes.profileDetailsScreen,
  builder: (context, state) {
    final id = state.uri.queryParameters['id'];
    return ProfileDetailsScreen(id: id);
  },
),
```

## App Router Wiring

`app_routing.dart` builds the `GoRouter` using `goRoutes` from `app_routes.dart`.

```dart
GoRouter(
  initialLocation: AppRoutes.splashScreen.path,
  routes: goRoutes,
)
```

## Best Practices

- **Unique paths**: Each `AppRoutes` entry should have a distinct path.
- **Named routes**: Use `pushNamed`/`goNamed` via helpers for consistency.
- **Dynamic data**: Prefer query parameters or path parameters via `GoRouterState`.
- **Centralized changes**: Keep all routing changes in `app_routes.dart` to avoid drift.
